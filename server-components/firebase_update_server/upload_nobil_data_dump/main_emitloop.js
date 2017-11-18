/* jshint esversion:6, node:true, undef:true, unused:true */
/* script to read output from db_dump api call from NOBIL database and write to
/ * database structure in firebase:
/ * stastion_idx: {
/ *      "name" : "name",
/ *      "address" : "address"
/ *      ..
/ *      chargers: {
/ *          "01": {
/ *              "type": "type",
/ *              "connector": "connector",
/ *              "capacity": "capacity"
/ *              ...
/ *          }
/ *          ..
/ * cities: {
/ *     station_id1: true,
/ *     station_id2: true,
/ * }
/ * counties: { 
/ *     station_id1: true,
/ *     station_id2: true,
/ * }
/ * municipalities: {
/ *     station_id1: true,
/ *     station_id2: true,
/ * }
/ *
/ *
/ * -> 29.08.2017 -> Completed read from file, parse and datastructure.
*/

"use strict";
// var db = require('./DatabaseStructures.js');
var staticObject = require('./staticObject.js');
var stationsObject = require('./stationsObject.js');


var fsread = require('./ReadNobilDataDump.js');
var parseArguments = require('./parseArguments.js');
// var progOptions=require('./progOptions.js');
var progOptions={};
var fswrite = require('./WriteProcessedNobilDump.js');
var myArgs=process.argv.slice(2);

//var serviceAccont = require("../cert/serviceAccountKey.json");
//var firebaseAppURL="https://ladeappen.firebaseio.com";
//v//ar firebase = require("firebase-admin");
var readline = require('readline');

//firebase.initializeApp({
//	credential: firebase.credential.cert(serviceAccont),
//	databaseURL: firebaseAppURL
//});
//var db = firebase.database();

// var myCities = new db.myStaticObject("Cities");
// var myCounties = new db.myStaticObject("Conties");
// var myMunicipality = new db.myStaticObject("Municipalities");
// var myStations = new db.myStationsObject("Stations");
// var myUnknown= [];
// var myCounter =0;
// var myValidArgumentList=true;

var myCities = new staticObject("Cities");
var myCounties = new staticObject("Conties");
var myMunicipality = new staticObject("Municipalities");
var myStations = new stationsObject("Stations");
var myUnknown= [];
var myCounter =0;
var myValidArgumentList=true;
var myArguments = new parseArguments();
// var test = require('./progOptions.js');
//ew parseArguments(progOptions.progOptions);

const EventEmitter = require('events');
class MyEmitter extends EventEmitter{}
const me = new MyEmitter();

//MyEmitter.prototype.startup = function myStuff() {
MyEmitter.prototype.startup = function myStuff() {
    me.emit('readprogOptions',function(err,data) {
     //   console.log(data.myObj);
    });
    me.emit('printprogOptions',function(err,data) {
    //   console.log(data);
    });

    me.emit('readNobilData');
}


me.on('printprogOptions', function(callback) {
    return callback(null,"print");
});

me.on('readprogOptions', function(callback){
    console.log("hei1");
  fsread.readJSON("progOptions.json",true, function(err, data) {
     if (err) {
        //console.log("Unable to read or parse program options.");
        return callback(1,"Unable to read or parse program options.");
     } else {
        myArguments.init(data.progOptions);
        myArguments.parse(myArgs,function(err,data) {
            if(err) {
                console.log(" ==> Invalid argumentlist : " + data);
                myValidArgumentList=false;
            } else {
                progOptions=data;
            }
        });
        return callback(null,myArguments);
    }
  });
});


me.on('readNobilData', function() {
    console.log("hei2");
    fsread.readJSON("my_db_dump", true, function(err, pkg) {
        if (!err) {
            for (var obj in pkg.chargerstations) {
                myStations.add(pkg.chargerstations[obj], function(err,myObj){
                    if (!err) {
                        myCounter++;
                        readline.cursorTo(process.stdout, 0);
                        myCities.add(pkg.chargerstations[obj].csmd.City, pkg.chargerstations[obj].csmd.International_id,true);  
                        myCounties.add(pkg.chargerstations[obj].csmd.County, pkg.chargerstations[obj].csmd.International_id,true);  
                        myMunicipality.add(pkg.chargerstations[obj].csmd.Municipality, pkg.chargerstations[obj].csmd.International_id,true);  
                        process.stdout.write(` ==> Reading: ${myObj}`);
                    } else {
                        myUnknown.push(myObj);
                    }
                });
            }
            readline.cursorTo(process.stdout, 0);
            process.stdout.write(` ==> Reading chargerstations completed - total ${myCounter} \n`);
            for (var i in myUnknown) {
                console.log(" ==> NOTE: International ID not specified for [ %s ] - skipped", myUnknown[i]);
            }

            fswrite.writeJSON("/tmp/myDump", myStations.myData,function(err) {
                if (err) {
                    console.log(" ==> Unable to save file");
                }
           });
    //    myStations.ShowData(true);
    //  myCities.ShowData(true);
    //  myCounties.ShowData();
    //  myMunicipality.ShowData();
   //   db.ref("subscriptions").update(myObj);
        }
        else {
            console.log("Unable to parse nobil data file. Aborting");
        }
    });
});

// myCheckArguments(myargs, function(err, data) {
//     if (err) {
 //        console.log(" ==> Invalid argumentlist: "  + data);
  //   }
// });

// console.log(myProgOptions);
    //

me.startup();

