/* test script. Purpose: read database (JSON format) into memory structure */

var fs = require('fs');
var usr_obj=JSON.parse(fs.readFileSync('./06_AuthorizedClients.json','utf-8'));
var PopulateSessionDB=function(obj) {
	var hat = require('hat'); //module for generating unique key
	var db={};
	for (var key in (obj)) {
		myKey=hat();
		db[myKey] = {"client" : key, "certificate" : obj[key], 'connected' : false};
	}
	return db;
 }
// var mySessionDB=new PopulateSessionDB(usr_obj);
var mySessionDB=new PopulateSessionDB(usr_obj);

// PopulateSessionDB(usr_obj,myDB);

for (var key in mySessionDB) {
	mySessionDB[key].connected="true";

};

// console.log(Object.keys(mySessionDB).some(key=>mySessionDB[key].includes('test1@localhost')));
console.log(JSON.stringify(mySessionDB));

console.log((Object.keys(mySessionDB).filter(key => mySessionDB[key].client=='test@localhost'))[0]);
if (!(Object.keys(mySessionDB).filter(key => mySessionDB[key].client=='test@localhost'))[0]) {
	console.log("missing");
}
