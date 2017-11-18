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
const MyPrint = require("/opt/ladeapp/lib/printConsole.js");
const jsjws = require('jsjws'); 
const fs = require('fs'); 
const myProcessName="FirebaseMessageBroker";

ipc.config.retry=1500;
ipc.config.id="nobilstream";
ipc.config.silent=true;


let myPrint =new MyPrint("csFavorite");
let usr_obj=JSON.parse(fs.readFileSync('AuthorizedClients.json','utf-8'));

let PopulateSessionDB=function(obj) {
	let db={};
	let hat = require('hat'); //module for generating unique key
	for (let key in (obj)) {
		let myKey=hat();
		db[myKey] = {'client' : key, 'certificate' : obj[key], 'connected' : false, 'heartbeat': 0 };
	}
	return db;
 };

let resetSessionDBEntry=function(key,sessdb) {
	let hat = require('hat'); //module for generating unique key
	let myKey=hat();
	let myObj={'client' : sessdb[key].client, 'certificate' : sessdb[key].certificate, 'connected' : false, 'heartbeat': 0 };
 	delete sessdb[key];
	sessdb[myKey]=myObj;
	return sessdb;
};

let resetAllSessions = function(sessionDB) {
    myPrint.warning("Session: " + "Disconnecting all active sessions..");
    Object.keys(sessionDB).forEach((key) => {
        if (sessionDB[key].connected) {
            myPrint.warning("Session: " + "Disconnecting session: [" + key + "]");
            sendMessageToClient(sessionDB[key].socket,'disconnect',{data:{message: "Serverprocess interrupted", key: key }});
            mySessionDB=resetSessionDBEntry(key,sessionDB);
        }
    });
}


let myHeartBeatTimeout=30000;   // 30 seconds heartbeat timeout 
let myHeartBeatCounter=2;       // heartbeat retries before disconnecting - assume down 
let mySessionDB=new PopulateSessionDB(usr_obj);

const EventEmitter = require('events');
class MyEmitter extends EventEmitter {}
const myFirebaseEmitter = new MyEmitter();

myFirebaseEmitter.on('upload',(record) => {
    let myConsoleMsg="Firebase: ";
    myPrint.note(myConsoleMsg + "Upload initiated" );
});


function sendMessageToClient(socket, type, msg){
    ipc.server.emit(socket, type, msg.data);
}

let nobilRealtime = function(data,socket,myDataPacketType) {
    let myConsoleMsg="Session(" + socket._handle.fd + "): ";
    let myUpdateConn= data.payload.key;
    let user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].connected==true))[0]; 
    if (user_key) {
        myPrint.info(myConsoleMsg + "Data packet [" + myDataPacketType + "] received (# "+ data.seq + "/" + JSON.stringify(data).length + "bytes) - " + myUpdateConn);          
        let myMessageData={data: {seq: data.seq, sessionKey: user_key}};
        myPrint.info(myConsoleMsg + "Sending acknowledge for packet [" + myDataPacketType + "] in (# " + data.seq + ")");
        sendMessageToClient(socket,myDataPacketType + ":ack",myMessageData);
        myFirebaseEmitter.emit('upload',data);
    } else {
        myPrint.warning(myConsoleMsg + "Data packet [" + myDataPacketType + "] received from unauthentucated session ("+ socket_id + ")");
    }
}

myPrint.note("Initialize: Service staring...");
myPrint.note("Initialize: Connecting to stream socket -> ["+ ipc.config.socketRoot + ipc.config.appspace + ipc.config.id + "]");

ipc.serve(function(){
    myPrint.note("Initialize: Connected to stream ["+ ipc.config.socketRoot + ipc.config.appspace + ipc.config.id + "] - awaiting requests...");

    setInterval(function() {
        Object.keys(mySessionDB).forEach(function(key) {
            if (mySessionDB[key].connected) {
                let myConsoleMsg="Session("+ mySessionDB[key].socket._handle.fd + "): ";
                if (mySessionDB[key].heartbeat < myHeartBeatCounter) {
                    mySessionDB[key].heartbeat +=1;
                    let myMessageData= {data: {message:  mySessionDB[key].client+ "/" + key, key: key}};
                    sendMessageToClient(mySessionDB[key].socket,'heartbeat',myMessageData); 
                    myPrint.note(myConsoleMsg + "Keep-alive request to [" + mySessionDB[key].client+ "] (" + key + ")");
                } else {
                    let myMessageData={data:{ message: mySessionDB[key].client +"/"+ key}};
                    sendMessageToClient(mySessionDB[key].socket,'disconnect',myMessageData);
                    mySessionDB=resetSessionDBEntry(key,mySessionDB);
                    myPrint.warning(myConsoleMsg + "Client [" + mySessionDB[key].client+ "/" + key + "] -> seems down, disconnecting session");
                } 
            }
        });
    },myHeartBeatTimeout);


    ipc.server.on('status:update',function(data,socket){
        // console.log(data.payload.payload.payload.key);
        nobilRealtime(data,socket,"status:update");
    });

    ipc.server.on('snapshot:init',function(data,socket){
        nobilRealtime(data,socket,"snapshot:init");
    });


    ipc.server.on('event_test',function(data,socket){
        var user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].socket==socket))[0]; 
        // let myLogMessage ={event: 'event_test', info: 'Data received from <'+ mySessionDB[user_key].client +'>' , data: (data)}; 
        // logTrail(6,myLogMessage); 
    });
  
    ipc.server.on('heartbeat',function(data,socket){
        let user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].connected === true))[0]; 
        if (user_key) {
            myPrint.note("Session(" + mySessionDB[user_key].socket._handle.fd + "): Heartbeat received from ["+ mySessionDB[user_key].client+"] ("+ user_key +")");
            mySessionDB[user_key].heartbeat=0;
        }
    });

    ipc.server.on('auth',function(data,socket){
        // try to validate if received message is a valid JWS by processing and extract information of the issuer 
        let myConsoleMsg="Authentcation(" + socket._handle.fd + "): ";
        let jws = new jsjws.JWS(); 
        jws.processJWS(data.jwt_sign); 
        var jws_payload=jws.getParsedPayload();
        if (jws_payload.iss == null) {
            let myMessageData={data: {message: 'Unable to parse token -> Token not in JWT format.'}};
            sendMessageToClient(socket,'reject',myMessageData);
            myPrint.warning(myConsoleMsg + "Authentication request refused | Unable to parse token | Token not in JWT format");
        } else {
            // checking for known issuer 
            myPrint.note(myConsoleMsg + "Received JWS token issued_by: [" + jws_payload.iss + "]");
            var user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].client==jws_payload.iss))[0]; 
            if (!user_key) {
                let myMessageData={data: {message: 'Connection not authorized -> not in list of autorized users'}};
                myPrint.warning(myConsoleMsg + "Authorization request refused | Token-issuer -> ["+ jws_payload.iss + "] not in list of authorized users");
                sendMessageToClient(socket,'reject',myMessageData);
            } else {
                // checking valid signature
                var pubCertFile = fs.readFileSync(mySessionDB[user_key].certificate); 
                var pub_pem = jsjws.X509.getPublicKeyFromCertPEM(pubCertFile.toString()); 
                if (!jws.verifyJWSByKey(data.jwt_sign, pub_pem, ['RS256'])) {
                    myPrint.warning(myConsoleMsg + "Authorization request refused | Invalid signature | Not signed with RS256");
                    let myMessageData={data: { message: 'Invalid signature -> not signed with RS256'}};
                    sendMessageToClient(socket,'reject',myMessageData);
                } else {
                    if (!mySessionDB[user_key].connected) {
                        mySessionDB[user_key].connected=true; 
                        mySessionDB[user_key].socket=socket; 
                        let myMessageData={data: {message: mySessionDB[user_key].client+"/"+user_key, key: user_key}};
                        myPrint.note(myConsoleMsg + "Client authenticated: [" + mySessionDB[user_key].client + "] (" + user_key + ")");
                        sendMessageToClient(socket,'open',myMessageData);
                    } else {
                        let myMessageData={data: {message: "Client [ " + mySessionDB[user_key].client +" ] allready active in other session!!"}};
                        myPrint.warning(myConsoleMsg + "Connection refused for client [" + mySessionDB[user_key].client +" ] -> Allready active in other session!!");
                        sendMessageToClient(socket,'reject',myMessageData);
                    }   
                }
            }  
        }
    });
  
    ipc.server.on('disconnect',function(data, socket) {
        var socket_id=socket._handle.fd;
        let myConsoleMsg="Session(" + socket_id + "): ";
        var key = data.key;
        var client=mySessionDB[key].client;
        myPrint.warning(myConsoleMsg + "Disconnect event received from ["+ client + "]");
        sendMessageToClient(socket,'disconnect',{data:{message: myProcessName, payload: 'Bye..' }});
        mySessionDB=resetSessionDBEntry(key,mySessionDB);
        myPrint.warning(myConsoleMsg +  "Session to [" + client + "] deleted from session table");
    });
});

process.on("SIGINT",() => {
    let myConsoleMsg="SIGINT: ";
    myPrint.warning(myConsoleMsg + "Session interrupted by user: SIGINT detected..");
    resetAllSessions(mySessionDB);
    setTimeout(() => process.exit(),2000);
}); 




// starting the server service
ipc.server.start();


