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
//console.log(usr_obj);
var PopulateSessionDB=function(obj) {
	var db={};
	var hat = require('hat'); //module for generating unique key
	for (var key in (obj)) {
		myKey=hat();
		db[myKey] = {"client" : key, "certificate" : obj[key], 'connected' : false};
	}
	return db;
 }
var mySessionDB=new PopulateSessionDB(usr_obj);

ipc.config.retry=1500;
ipc.config.id="nobilstream";
ipc.config.silent=true;


function rejectConnection(socket,errcode, msg){
  ipc.server.emit(socket,'reject', "Access denied" +" reason: "+ msg);
  logTrail(1,"access denied. reason: " + msg);
}



logTrail(6,"Server started");
logTrail(6,"Opening stream [ "+ ipc.config.socketRoot + ipc.config.appspace + ipc.config.id + " ]");
//PopulateSessionDB(usr_obj,mySessionDB);
console.log(mySessionDB);
ipc.serve(function(){
  logTrail(6,"Connected do stream [ "+ ipc.config.socketRoot + ipc.config.appspace + ipc.config.id + " ]");
  ipc.server.on('event_test',function(data,socket){
    ipc.log('HE_received_conect: ', data);
	  console.log(data);
  });
  ipc.server.on('auth',function(data,socket){
    // try to validate if received message is a valid JWS by processing and extract information of the issuer 
    var jws = new jsjws.JWS(); 
    jws.processJWS(data.jwt_sign); 
    var jws_payload=jws.getParsedPayload();
    if (jws_payload.iss == null) {
      rejectConnection(socket,4,"Invalid request");
    } else {
      // checking for known issuer 
      // var known_clients=JSON.parse(fs.readFileSync('AuthorizedClients.json','utf-8'));
      logTrail(6,"Received JWS token issued by " + jws_payload.iss );
      var user_key = (Object.keys(mySessionDB).filter(key => mySessionDB[key].client==jws_payload.iss))[0]; 
      if (!user_key) {
        rejectConnection(socket,3,"Token-issuer '" + jws_payload.iss + "' unknown to me.");
      } else {
	// checking valid signature
        var pubCertFile = fs.readFileSync(mySessionDB[user_key].certificate); 
        var pub_pem = jsjws.X509.getPublicKeyFromCertPEM(pubCertFile.toString()); 
        if (!jws.verifyJWSByKey(data.jwt_sign, pub_pem, ['RS256'])) {
          rejectConnection(socket,3,"Invalid signature");
        } else {
           mySessionDB[user_key].connected=true; 
           // jws_payload=jws.getParsedPayload();
	   logTrail(6,"Client connection request for "+ mySessionDB[user_key].client + " authenticated successfully");
           ipc.server.emit(socket,'open',  user_key );
	   console.log(mySessionDB[user_key]);
        }
      }  
    }
  });
});
ipc.server.start();


function logTrail(errcode,msg){
  var errText ="";
  switch (errcode){
    case 1: 
	  errText="alert: ";
	  break;
    case 2:
	  errText="critical: ";
	  break;
    case 3:
          errText="error: ";
	  break;
    case 4:
          errText="Warning: ";
	  break;
    case 5:
          errText="notice: ";
	  break;
    case 6:
          errText="info: ";
	  break;
    case 7:
          errText="debug: ";
	  break;
    }
    ipc.log(Date() + " " + errText + msg);
    console.log(Date() + " " + errText + msg);
}


