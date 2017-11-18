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
var pubCertFile = fs.readFileSync('./certs/NobilStreamReceiver_local.crt'); 
var pub_pem = jsjws.X509.getPublicKeyFromCertPEM(pubCertFile.toString()); 

function rejectConnection(socket){
  ipc.server.emit(socket,'reject', "Uauthorized request");
 // ipc.log("Client request rejected - invalid signature");
}
  


ipc.config.id='world';
ipc.config.retry=1500;

ipc.serve(function(){
  ipc.server.on('event_test',function(data,socket){
    ipc.log('HE_received_conect: ', data);
	  console.log(data);
  });
  ipc.server.on('auth',function(data,socket){
    // try to validate is received message is a valid JWS by processing and extract information of issuer 
    var jws = new jsjws.JWS(); 
    jws.processJWS(data.jwt_sign); 
    var jws_payload=jws.getParsedPayload();
    if (jws_payload.iss == null) {
      rejectConnection(socket);
    } else {
      // checking for known client
      //ipc.log("Client request from: ", { iss: jws_payload.iss});
      //read file containing known clients
      known_clients=JSON.parse(fs.readFileSync('AuthorizedClients.json','utf-8'));
      //if (jws.getParsedPayload(['iss'])=known_clients[jws.getParsedPayload(['iss'])]) {
      if (!known_clients[jws_payload.iss]) {
        rejectConnection(socket);
      } else {
        // ipc.log("Client request received :", data.jwt_sign);
	// checking valid signature
        var pubCertFile = fs.readFileSync(known_clients[jws_payload.iss]); 
        var pub_pem = jsjws.X509.getPublicKeyFromCertPEM(pubCertFile.toString()); 
        if (!jws.verifyJWSByKey(data.jwt_sign, pub_pem, ['RS256'])) {
          rejectConnection(socket);
        } else {
           jws_payload=jws.getParsedPayload();
           ipc.log("Client request accepted: ", { iss: jws_payload.iss});
           ipc.server.emit(socket,'open', "-> Access authorized");
           console.log("Cert-File: " + known_clients[jws_payload.iss]);
        }
      }  
    }
//   assert(jws.verifyJWSByKey(sig, pub_pem, ['RS256'])); 
//    assert.deepEqual(jws.getParsedHeader(), header); 
//    assert.equal(jws.getUnparsedPayload(), JSON.stringify(payload)); 
//    console.log("UnparsedHeader: " + jws.getUnparsedHeader()); 
//    console.log("UnparsedPayload: " + jws.getUnparsedPayload());
//    console.log("iat: " + myTime_iat + "   exp: " + (myTime_iat + 600));
  });
});
ipc.server.start();


