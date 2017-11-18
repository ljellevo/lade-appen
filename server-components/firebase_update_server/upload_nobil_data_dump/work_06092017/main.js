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
var staticObject = require('./staticObject.js');
var stationsObject = require('./stationsObject.js');
var fsread = require('./ReadNobilDataDump.js');
var parseArguments = require('./parseArguments.js');
var fswrite = require('./WriteProcessedNobilDump.js');
var myArgs=process.argv.slice(2);
var fs = require('fs');

//var serviceAccont = require("../cert/serviceAccountKey.json");
//var firebaseAppURL="https://ladeappen.firebaseio.com";
//v//ar firebase = require("firebase-admin");
var readline = require('readline');

//firebase.initializeApp({
//	credential: firebase.credential.cert(serviceAccont),
//	databaseURL: firebaseAppURL
//});
//var db = firebase.database();

var myCities = new staticObject("Cities");
var myCounties = new staticObject("Conties");
var myMunicipality = new staticObject("Municipalities");
var myStations = new stationsObject("Stations");
var myUnknown= [];
var myCounter =0;
var myArguments =  new parseArguments();


function ensureFolderExists(path,mask,callback) {
    if (typeof mask == 'function') {
        callback=mask;
        mask='0744';
    }
    fs.mkdir(path,mask,function(err) {
        if (err) {
            if (err.code == 'EEXIST') {
                return callback(null);
            } else {
                return callback(err);
            }
        } else {
            return callback(null);
        }
    });
}

fsread.readJSON("progOptions.json",true, function(err, data) {
    if (!err) {
        myArguments.init(data.progOptions);
        myArguments.parse(myArgs,function(err,data,help) {
            if (!err) {
                ensureFolderExists(myArguments.myObj["-d"].value,"0775", function(err) {
                    if (err) {
                        console.log(" ==! Failed to create output folder, reason: " + err);
                        process.exit(1); 
                    } else {
                        var myOutputFolder=myArguments.myObj["-d"].value;
                        var myOutputFilePrefix=myArguments.myObj["-p"].value;
                        console.log(" ==> INFO: Using output folder [ " + myArguments.myObj["-d"].value + " ].");
                        console.log(" ==> INFO: All outputfiles are prefixed with [ " + myArguments.myObj["-p"].value + " ].");
                        console.log(" ==> INFO: Start reading input from file [ " + myArguments.myObj["-i"].value + " ].");
                        fsread.readJSON(myArguments.myObj["-i"].value, true, function(err, data) {
                            if (!err) {
                                for (var obj in data.chargerstations) {
                                    myStations.add(data.chargerstations[obj], function(err,myObj){
                                        if (!err) {
                                            myCounter++;
                                            readline.cursorTo(process.stdout, 0);
                                            myCities.add(data.chargerstations[obj].csmd.City, data.chargerstations[obj].csmd.International_id,true);  
                                            myCounties.add(data.chargerstations[obj].csmd.County, data.chargerstations[obj].csmd.International_id,true);  
                                            myMunicipality.add(data.chargerstations[obj].csmd.Municipality, data.chargerstations[obj].csmd.International_id,true);  
                                            process.stdout.write(`     Reading: ${myObj}`);
                                        } else {
                                            myUnknown.push(myObj);
                                        }
                                    });
                                }
                                readline.cursorTo(process.stdout, 0);
                                process.stdout.write(` ==> INFO: Reading chargerstations completed - total ${myCounter} \n`);
                                for (var i in myUnknown) {
                                    console.log(" ==> NOTE: International ID not specified for [ %s ] - skipped", myUnknown[i]);
                                }

                                fswrite.writeJSON("/tmp/myDump", myStations.myData,function(err) {
                                    if (err) {
                                        console.log(" ==! Unable to save file");
                                    }
                                });
    //    myStations.ShowData(true);
    //  myCities.ShowData(true);
    //  myCounties.ShowData();
    //  myMunicipality.ShowData();
   //   db.ref("subscriptions").update(myObj);
                            }   
                            else {
                                console.log(" ==! Unable to parse NOBIL data dump file. Reason -> " + err);
                            }
                        });
                    }
                });
            }
            else {
                if (help) {
                    myArguments.print(true,true);
                    return;
                } else {
                    console.log(" ==! Invalid argumentlist : " + err);
                    myArguments.print(true,false);
                    return;
                }
            }
        });
    } 
    else {
        console.log(" ==! Unable to read or parse program options. Reason -> " + err);
        return;
    }
});

