/* jshint esversion:6, node:true, undef:true, unused:true */

/*
PoC authenticaton over IPC communication using certificates.
Authentication process handles in signet JWT token style.
{header}.{claim}.{dist} - all base64url encoded.

This script represent server side  - receiving request
i.e. process forwaring to google firebase database
typically from process handling nobil stream updates

08.10.2017 - add flowcontrol - starting....


*/


const ipc=require('node-ipc');
let MyPrint = require("/opt/ladeapp/lib/printConsole.js");
let myPrint =new MyPrint("csFavorite");
var jsjws = require('jsjws'); 
var fs = require('fs'); 
var myProcessName="FirebaseMessageBroker";
var usr_obj=JSON.parse(fs.readFileSync('AuthorizedClients.json','utf-8'));
var PopulateSessionDB=function(obj) {
	var db={};
	var hat = require('hat'); //module for generating unique key
	for (var key in (obj)) {
		var myKey=hat();
		db[myKey] = {'client' : key, 'certificate' : obj[key], 'connected' : false, 'heartbeat': 0 };
	}
	return db;
 };
var resetSessionDBEntry=function(key,sessdb) {
	var hat = require('hat'); //module for generating unique key
	var myKey=hat();
	var myObj={'client' : sessdb[key].client, 'certificate' : sessdb[key].certificate, 'connected' : false, 'heartbeat': 0 };
 	delete sessdb[key];
	sessdb[myKey]=myObj;
	return sessdb;
};

var mySessionDB=new PopulateSessionDB(usr_obj);

ipc.config.retry=1500;
ipc.config.id="nobilstream";
ipc.config.silent=true;





const EventEmitter = require('events');
class MyEmitter extends EventEmitter {}
const myFirebaseEmitter = new MyEmitter();

myFirebaseEmitter.on('upload',(record) => {
    let myLogMessage= {event: "Firebase", info: "Upload to firebase", data: {message: "Data ready to be uploafed to firebase"}};
    logTrail(6,myLogMessage);
  //   console.log(record);
  //  console.log("jepp");
});



function sendMessageToClient(socket, type, syslog_code, msg){
  ipc.server.emit(socket, type, msg.data);
  logTrail(syslog_code,msg);
}


let myLogMessage= {event: "Startup", info: "Service staring", data: {message: "Initializing.."}};

logTrail(6,myLogMessage);
//myLogMessage= {event: "Startup", info: "Stream socket" , data: {message: "Connecting to stream socket -> ["+ ipc.config.id + "]"}};
myPrint.note("Starting up, Stream socket, Connecting to stream socket -> ["+ ipc.config.id + "]");
// logTrail(5,myLogMessage);

ipc.serve(function(){
//  let myLogMessage= {event: "Connection", info: "Connected to stream", data: {message: "waiting for requests..."}};
  myPrint.note("Connection: Connected to streami, waiting for requests...");
//  logTrail(5,myLogMessage);
  
  setInterval(function() {
    Object.keys(mySessionDB).forEach(function(key) {
      if (mySessionDB[key].connected) {
        if (mySessionDB[key].heartbeat < 5) {
           mySessionDB[key].heartbeat +=1;
            let myLogMessage= { event: 'Heartbeat', info: "Sending request", data: {message:  mySessionDB[key].client+ "/" + key }};
           sendMessageToClient(mySessionDB[key].socket,'heartbeat',5,myLogMessage); 
        } else {
            let myLogMessage={event: "Heartbeat", info:"No answer, disconnecting", data:{ message: mySessionDB[key].client +"/"+ key}};
           sendMessageToClient(mySessionDB[key].socket,'disconnect',1,myLogMessage);
           mySessionDB=resetSessionDBEntry(key,mySessionDB);
        } 
      }
    });
  },15000);


  ipc.server.on('status:update',function(data,socket){
    // ipc.log('HE_received status:update packet: ', data);
    var user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].connected==true))[0]; 
      if (user_key) {
        let myLogMessage={event: "Communication", info: "Packet received", data: { message: "Session: " + user_key + " / " + "status:update, # " + data.payload.seq + "(" + JSON.stringify(data).length + ")", sessionKey: user_key, dataPacket: data.payload.seq}};
        logTrail(6,myLogMessage);
        // logTrail(6, {event: 'status:upadate', info: 'Data received from <'+ mySessionDB[user_key].client +'>' , data: (data)});
        myLogMessage={event: "Communication", info: "Sending acknowledge", data: { message: "Session: " + user_key + " / " + "status:update, # " + data.payload.seq, sessionKey: user_key, dataPacket: data.payload.seq}};
        sendMessageToClient(socket,'status:update',6,myLogMessage);
        myFirebaseEmitter.emit('upload',data);
      } else {
        myLogMessage={event: "Communication", info: "Data received from unauthentucated session", data: {message: "packettype -> status:update"}};
        logTrail(1,myLogMessage); 
      }
  });

  ipc.server.on('event_test',function(data,socket){
    ipc.log('HE_received_conect: ', data);
    var user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].socket==socket))[0]; 
      let myLogMessage ={event: 'event_test', info: 'Data received from <'+ mySessionDB[user_key].client +'>' , data: (data)}; 
      logTrail(6,myLogMessage); 
  });
  
  ipc.server.on('heartbeat',function(data,socket){
    var user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].connected==true))[0]; 
    if (user_key) {
      let myLogMessage={event: 'Heartbeat', info: 'Heartbeat received', data: {message: mySessionDB[user_key].client+'/'+ user_key }};
      logTrail(5,myLogMessage); 
      mySessionDB[user_key].heartbeat=0;
    }
  });

  ipc.server.on('auth',function(data,socket){
    // try to validate if received message is a valid JWS by processing and extract information of the issuer 
    var jws = new jsjws.JWS(); 
    jws.processJWS(data.jwt_sign); 
    var jws_payload=jws.getParsedPayload();
    if (jws_payload.iss == null) {
      sendMessageToClient(socket,'reject',1,{event: 'Authentcation', info: 'Authentication request refused', data: {message: 'Unable to parse token -> Token not in JWT format.'}});
    } else {
      // checking for known issuer 
      logTrail(6,{event: 'Authentication', info: "Received JWS token", issued_by: jws_payload.iss, data:(data)});
      var user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].client==jws_payload.iss))[0]; 
      if (!user_key) {
        sendMessageToClient(socket,'reject',3,{event: 'Authentication', info: 'Authorization request refused', data: {message: 'Unknown token-issuer -> '+ jws_payload.iss + ' not in list of autorized users'}});
      } else {
	// checking valid signature
        var pubCertFile = fs.readFileSync(mySessionDB[user_key].certificate); 
        var pub_pem = jsjws.X509.getPublicKeyFromCertPEM(pubCertFile.toString()); 
        if (!jws.verifyJWSByKey(data.jwt_sign, pub_pem, ['RS256'])) {
          sendMessageToClient(socket,'reject',3,{event: "Authenticarion", info: 'Authorization request refused',data: { message: 'Invalid signature -> Only RS256 is supported.'}});
        } else {
	   if (!mySessionDB[user_key].connected) {
             mySessionDB[user_key].connected=true; 
             mySessionDB[user_key].socket=socket; 
             sendMessageToClient(socket,'open',6,{ event: "Authentication", info: 'Authentication confirmed', user_key, data: {message: mySessionDB[user_key].client+"/"+user_key, key: user_key}});
	   } else {
             sendMessageToClient(socket,'reject',3,{event: "Authentication", info: 'Connection refused', data: {message: "Client [ " + mySessionDB[user_key].client +" ] allready active in other session!!"}});
	   }   
        }
      }  
    }
  });
  
  ipc.server.on('disconnect',function(data, socket) {
    var key = data.key;
    var client=mySessionDB[key].client;
    var socket_id=socket._handle.fd;
    logTrail(4, {event: 'Disconnect', info:'Disconnect event received', data: { message: client, payload: socket_id}});
//     sendMessageToClient(socket,'disconnect',6,{event: 'Disconnect', info: 'Sending disconnect confirmation', data:{message: myProcessName, payload: 'Bye..' }});
    mySessionDB=resetSessionDBEntry(key,mySessionDB);
    logTrail(4, {event: 'Disconnect', info: 'Session in state database deleted', data: { message: client, payload: socket_id}});
  });
});

ipc.server.start();


function logTrail(errcode,msg){
  var errText ="";
  switch (errcode){
    case 1: 
	  errText="alert";
	  break;
    case 2:
	  errText="critical";
	  break;
    case 3:
          errText="error";
	  break;
    case 4:
          errText="warning";
	  break;
    case 5:
          errText="notice";
	  break;
    case 6:
          errText="info";
	  break;
    case 7:
          errText="debug";
	  break;
    }
    var now= new Date();
	now.setMinutes(now.getMinutes()-now.getTimezoneOffset());
    //// nice colorized output
     var message = {"Timestamp" : now, "Severity" : errText, "message": msg};
    //  console.dir(message, {depth: 5, colors: true});

    var message2 = Date() + " : " + errText + " : " + msg.event +" : " + msg.info + " : " + msg.data.message;
     console.log(message2);



}


