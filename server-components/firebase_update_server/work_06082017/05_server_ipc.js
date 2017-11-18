/*

PoC authenticaton over IPC communication using certificates.
Authentication process handles in signet JWT token style.
{header}.{claim}.{dist} - all base64url encoded.

This script represent server side  - receiving request
i.e. process forwaring to google firebase database
typically from process handling nobil stream updates


*/
const ipc=require('node-ipc');
var assert = require('assert'); 
var jsjws = require('jsjws'); 
var fs = require('fs'); 
ipc.config.retry=1500;
ipc.config.id="nobilstream";
ipc.config.silent=true;
var myProcessName="FirebaseMessageBroker";

function rejectConnection(socket,errcode, msg){
  ipc.server.emit(socket,'reject', "Access denied" +" reason: "+ msg);
  logTrail(1,"access denied. reason: " + msg);
}

logTrail(6,"Server started");
logTrail(6,"Opening stream [ "+ ipc.config.socketRoot + ipc.config.appspace + ipc.config.id + " ]");

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
      rejectConnection(socketi,4,"Invalid request");
    } else {
      // checking for known issuer 
      known_clients=JSON.parse(fs.readFileSync('AuthorizedClients.json','utf-8'));
      logTrail(6,"Received JWS token issued by " + jws_payload.iss );
      if (!known_clients[jws_payload.iss]) {
        rejectConnection(socket,3,"Token-issuer '" + jws_payload.iss + "' unknown to me.");
      } else {
	// checking valid signature
        var pubCertFile = fs.readFileSync(known_clients[jws_payload.iss]); 
        var pub_pem = jsjws.X509.getPublicKeyFromCertPEM(pubCertFile.toString()); 
        if (!jws.verifyJWSByKey(data.jwt_sign, pub_pem, ['RS256'])) {
          rejectConnection(socket,3,"Invalid signature");
        } else {
           jws_payload=jws.getParsedPayload();
	   logTrail(6,"Client connection request for "+ jws_payload.iss + " authenticated successfully");
           ipc.server.emit(socket,'open',  myProcessName );
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
	  errText="alert: "
	  break;
    case 2:
	  errText="critical: "
	  break;
    case 3:
          errText="error: "
	  break;
    case 4:
          errText="Warning: "
	  break;
    case 5:
          errText="notice: "
	  break;
    case 6:
          errText="info: "
	  break;
    case 7:
          errText="debug: "
	  break;
    }
    ipc.log(Date() + " " + errText + msg);
    console.log(Date() + " " + errText + msg);
}
