/*
PoC node.js script for secure IPC communication
Goal:
    - authentication: ensure connection only accepted by authorized client application
    - encryption: ensure privacy in communicationpath

Authentication used with selfsigned certificates
Encryption with DH Public key

*/

const ipc=require('node-ipc');

//ipc.config.silent=true;
ipc.config.id='world';
ipc.config.retry=1500;
ipc.config.networkHost='localhost';
ipc.config.tls= {
	public: __dirname+'/../cert/FirebaseUpdateServer_local.crt',
	private: __dirname+'/../cert/FirebaseUpdateServer_local.key',
	dhparam: __dirname+'/../cert/dhparam_internal.pem',
	requestCert: true,
	rejectUnauthorized: false,
	trustedConnections: [
		__dirname+'/../cert/NobilStreamReceiver_local.pub'
	]};


ipc.serve(function(){
  ipc.server.on('message',function(data,socket){
    ipc.server.emit(socket,'message:', 'message from server '+ data);
  });
  ipc.server.on('socket.disconnected', function(data,socket){
    console.log('client disconnectet');
  });
});

ipc.server.start();
