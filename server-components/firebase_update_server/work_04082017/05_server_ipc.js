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


ipc.config.id='world';
ipc.config.retry=1500;

ipc.serve(function(){
  ipc.server.on('app.message',function(data,socket){
    ipc.server.emit(socket,'app.message', {id:ipc.config.id, message: data.message+' world'});
    ipc.log('HE_received: ', data.jwt_sign);
    var jws = new jsjws.JWS(); 
    if (jws.verifyJWSByKey(data.jwt_sign, pub_pem, ['RS256'])) {
	   console.log("DIGIT OK");
        var jwt_payload=jws.getParsedPayload();
	   console.log("header: "+ jwt_payload["iss"]);
   } 
//    assert(jws.verifyJWSByKey(sig, pub_pem, ['RS256'])); 
//    assert.deepEqual(jws.getParsedHeader(), header); 
//    assert.equal(jws.getUnparsedPayload(), JSON.stringify(payload)); 
//    console.log("UnparsedHeader: " + jws.getUnparsedHeader()); 
//    console.log("UnparsedPayload: " + jws.getUnparsedPayload());
//    console.log("iat: " + myTime_iat + "   exp: " + (myTime_iat + 600));
  });
});
ipc.server.start();


var assert = require('assert'); 
var jsjws = require('jsjws'); 
var fs = require('fs'); 


var pubCertFile = fs.readFileSync('./certs/NobilStreamReceiver_local.crt'); 
var pub_pem = jsjws.X509.getPublicKeyFromCertPEM(pubCertFile.toString()); 

//fs.writeFile(myJWTToken,sig,(err) => {
//if (err) throw err;
//	console.log("JWT file created successfully");
//});

// var jws = new jsjws.JWS(); 
// assert(jws.verifyJWSByKey(sig, pub_pem, ['RS256'])); 
//assert.deepEqual(jws.getParsedHeader(), header); 
//assert.equal(jws.getUnparsedPayload(), JSON.stringify(payload)); 
//console.log("UnparsedHeader: " + jws.getUnparsedHeader()); 
//console.log("UnparsedPayload: " + jws.getUnparsedPayload());
//console.log("iat: " + myTime_iat + "   exp: " + (myTime_iat + 600));
