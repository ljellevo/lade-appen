/* jshint esversion:6, node:true, undef:true, unused:true */

/*
PoC authenticaton over IPC communication using certificates.
Authentication process handles in signet JWT token style.
{header}.{claim}.{dist} - all base64url encoded.

This script represent server side  - receiving request
i.e. process forwaring to google firebase database
typically from process handling nobil stream updates
*/


const ipc=require('node-ipc');
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


function sendMessageToClient(socket, type, syslog_code, msg){
  ipc.server.emit(socket, type, msg.data);
  logTrail(syslog_code,msg);
}


logTrail(6,{ event: "Server started", Application: myProcessName});
logTrail(6,{ event: "Creating stream..", info: ipc.config.socketRoot + ipc.config.appspace + ipc.config.id});

ipc.serve(function(){
  logTrail(5,"Connected to stream, awaiting requests.");
  
  setInterval(function() {
    Object.keys(mySessionDB).forEach(function(key) {
      if (mySessionDB[key].connected) {
        if (mySessionDB[key].heartbeat < 5) {
           mySessionDB[key].heartbeat +=1;
           sendMessageToClient(mySessionDB[key].socket,'heartbeat',6, { event: 'heartbeat', info: "Sending heartbeat to " + mySessionDB[key].client, data: {message: "req", payload: myProcessName}});
        } else {
           logTrail(3,"Session to client [ "+mySessionDB[key].client + "] not responding - seems down, force disconnect.");
           sendMessageToClient(mySessionDB[key].socket,'disconnect',6,"Session disconnected.");
           mySessionDB=resetSessionDBEntry(key,mySessionDB);
        } 
      }
    });
  },15000);


  ipc.server.on('event_test',function(data,socket){
    ipc.log('HE_received_conect: ', data);
    var user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].socket==socket))[0]; 
      logTrail(6, {event: 'event_test', info: 'Data received from <'+ mySessionDB[user_key].client +'>' , data: (data)});
	  // console.log(data);
  });
  
  ipc.server.on('heartbeat',function(data,socket){
    var user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].socket==socket))[0]; 
    if (user_key) {
      logTrail(6, {event: 'heartbeat', info: 'Heartbeat message received from <'+ mySessionDB[user_key].client +'>' , data: (data)});
      mySessionDB[user_key].heartbeat=0;
    }
  });

  ipc.server.on('auth',function(data,socket){
    // try to validate if received message is a valid JWS by processing and extract information of the issuer 
    var jws = new jsjws.JWS(); 
    jws.processJWS(data.jwt_sign); 
    var jws_payload=jws.getParsedPayload();
    if (jws_payload.iss == null) {
      sendMessageToClient(socket,'reject',1,{event: 'Authentcation', info: 'Authentication request refused', data: {message: 'Unable to parse token', reason: 'Token not in JWT format.'}});
    } else {
      // checking for known issuer 
      logTrail(6,{event: 'Authentication', info: "Received JWS token", issued_by: jws_payload.iss, data:(data)});
      var user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].client==jws_payload.iss))[0]; 
      if (!user_key) {
        sendMessageToClient(socket,'reject',3,{event: 'Authentication', info: 'Authorization request refused', data: {message: 'Unknown token-issuer', reason: jws_payload.iss + ' not in list of autorized users'}});
      } else {
	// checking valid signature
        var pubCertFile = fs.readFileSync(mySessionDB[user_key].certificate); 
        var pub_pem = jsjws.X509.getPublicKeyFromCertPEM(pubCertFile.toString()); 
        if (!jws.verifyJWSByKey(data.jwt_sign, pub_pem, ['RS256'])) {
          sendMessageToClient(socket,'reject',3,{event: "Authenticarion", info: 'Authorization request refused',data: { message: 'Invalid signature', reason: 'Only RS256 is supported.'}});
        } else {
	   if (!mySessionDB[user_key].connected) {
             mySessionDB[user_key].connected=true; 
             mySessionDB[user_key].socket=socket; 
             sendMessageToClient(socket,'open',6,{ event: "Authentication", info: 'Authentication confirmed', client: mySessionDB[user_key].client, data: {server: myProcessName, key: user_key }});
	   } else {
             sendMessageToClient(socket,'reject',3,{event: "Authentication", info: 'Connection refused', data: {message: mySessionDB[user_key].client, reason: 'Client allready active in other connection!!'}});
	   }   
        }
      }  
    }
  });
  
  ipc.server.on('disconnect',function(data, socket) {
    var key = data.key;
    var client=mySessionDB[key].client;
    var socket_id=socket._handle.fd;
    logTrail(6, {event: 'Disconnect', info:'Disconnect event received', data: { message: client, payload: socket_id}});
//     sendMessageToClient(socket,'disconnect',6,{event: 'Disconnect', info: 'Sending disconnect confirmation', data:{message: myProcessName, payload: 'Bye..' }});
    mySessionDB=resetSessionDBEntry(key,mySessionDB);
    logTrail(6, {event: 'Disconnect', info: 'Session in state database deleted', data: { message: client, payload: socket_id}});
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
    var message = {"Timestamp" : now, "Severity" : errText, "message": msg};
 //   var message2 = Date() + ": " + errText + ": " + msg;

    // console.log(JSON.stringify(message,null,2));
     console.dir(message, {depth: 5, colors: true});
}


