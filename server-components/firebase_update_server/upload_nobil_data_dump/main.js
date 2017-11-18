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
var printConsole = require('./printConsole.js');
var readline = require('readline');

//var serviceAccont = require("../cert/serviceAccountKey.json");
var firebaseAppURL="https://ladeappen.firebaseio.com";
//v//ar firebase = require("firebase-admin");

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
var myPrint = new printConsole();
var cs = "csFavorite";

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
                        myPrint.log("Info", "Using output folder [ " + myArguments.myObj["-d"].value + " ]",cs);
                        myPrint.log("Info", "All outputfiles are prefixed with [ " + myArguments.myObj["-p"].value + " ].",cs);
                        myPrint.log("Info", "Start reading input from file [ " + myArguments.myObj["-i"].value + " ].",cs);
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
                                myPrint.log("Note","Reading chargerstations completed - total "+ myCounter, cs);
                                for (var i in myUnknown) {
                                    myPrint.log("Warning","International ID not specified for [ " + myUnknown[i] + " ] - skipped",cs);
                                }

                                //fswrite.writeJSON("/tmp/myDump", myStations.myData,function(err) {
                                fswrite.writeJSON(myOutputFolder + "/"+myOutputFilePrefix+myStations.myKey, myStations.myData,function(err) {
                                    myPrint.log("Note", "Saving JSON structure for all stations -> " + myOutputFolder + "/"+myOutputFilePrefix+myStations.myKey,cs);
                                    if (err) {
                                        myPrint.log("Error", "Unable to save file. Reason -> " + err, cs);
                                    }
                                });
                                fswrite.writeJSON(myOutputFolder + "/"+myOutputFilePrefix+myCities.key, myCities.data,function(err) {
                                    myPrint.log("Note", "Saving JSON structure for all cities -> " + myOutputFolder + "/"+myOutputFilePrefix+myCities.key,cs);
                                    if (err) {
                                        myPrint.log("Error", "Unable to save file. Reason -> " + err, cs);
                                    }
                                });
                                fswrite.writeJSON(myOutputFolder + "/"+myOutputFilePrefix+myCounties.key, myCounties.data,function(err) {
                                    myPrint.log("Note", "Saving JSON structure for all counties -> " + myOutputFolder + "/"+myOutputFilePrefix+myCounties.key,cs);
                                    if (err) {
                                        myPrint.log("Error", "Unable to save file. Reason -> " + err, cs);
                                    }
                                });
                                fswrite.writeJSON(myOutputFolder + "/"+myOutputFilePrefix+myMunicipality.key, myMunicipality.data,function(err) {
                                    myPrint.log("Note", "Saving JSON structure for all municipalities -> " + myOutputFolder + "/"+myOutputFilePrefix+myMunicipality.key,cs);
                                    if (err) {
                                        myPrint.log("Error", "Unable to save file. Reason -> " + err, cs);
                                    }
                                });
                                // check if upload option set on commandline, default is not to upload.
                                if (myArguments.isSet("-u")) {
                                    myPrint.log("Note","Starting upload to firebase database", cs);
                                    myPrint.log("Info","-> " + firebaseAppURL+"/stations", cs);
                                    //db.ref("subscriptions").update(myObj);
                                    myPrint.log("Info","-> " + firebaseAppURL+"/cities", cs);
                                    myPrint.log("Info","-> " + firebaseAppURL+"/counties", cs);
                                    myPrint.log("Info","-> " + firebaseAppURL+"/municipalities", cs);
                                } else {
                                    myPrint.log("Warning","No upload to firebase realtime database performed. Firebase database unchanged.", cs);
                                };
                            }   
                            else {
                                myPrint.log("Error", "Unable to parse NOBIL chargerstation data in dump file. Reason -> " + err, cs);
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
                    myPrint.log("Error","Invalid argumentlist : " + err,cs);
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

