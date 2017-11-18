/* jshint esversion:6, node:true, undef:true, unused:true */

//
// MAIN PROGRAM 
//
// this program:
//      - query NOBIL API for chargerstation information bases on query given in parameter
//      - parse received data into structure for fireabase realtime database
//      - upload to firebase realtime database.
//
//
// 23.09.2017 -> verified.

"use strict";
var Promise = require('promise');
var getProgArguments = require('./getProgArguments.js');
var parseNobilDatabaseDump = require('./parseNobilDatabaseDump.js');
var getNobilDatabaseDump = require('./getNobilDatabaseDump.js');
var progOptionsObj = require('./progOptionsObj.js');
var myConstants = require('./constantValues.json');
var constantsParams = myConstants.constantsParameters;
var readFile = require('./readFile.js');
var uploadToFirebase = require('./uploadToFirebase.js'); 
var printConsole = require('./printConsole.js');

var myArgObj = new progOptionsObj();
var myPrint = new printConsole("csFavorite");


getProgArguments("progOptions.json",myArgObj)
    .then(function() {
        myPrint.warning("Starting process for updating firebase realtime database used by LADEAPP..");
        if (myArgObj.myObj[constantsParams.loadFromNobil].set) {
            myPrint.info("Initiate NOBIL database download from [" + myArgObj.myObj[constantsParams.nobilAPIURL].value + "]");
            myPrint.info("Use query specified in file [" + myArgObj.myObj[constantsParams.nobilAPIQuery].value + "]");
            return getNobilDatabaseDump(myArgObj.myObj[constantsParams.nobilAPIURL].value,myArgObj.myObj[constantsParams.nobilAPIQuery].value);
        } else {
            myPrint.info("Use previously downloaded NOBIL database dump, file -> [" + myArgObj.myObj[constantsParams.databaseInputFile].value + "]");
            return readFile(myArgObj.myObj[constantsParams.databaseInputFile].value,true);
        }
    })
    .then(function(response) {
        // console.dir(response.chargerstations);
        //ready to create database structure for firebase 
        myPrint.note("Building database structures for firebase realtime database..");
        return parseNobilDatabaseDump(response);
    })
    .then(function(response) {
        // ready to upload to firebase    
        myPrint.note("Building database structures for firebase realtime database competed successfully.");
        myPrint.note("Starting upload to firebase realtime database..");
        return uploadToFirebase(myArgObj.myObj[constantsParams.serviceAccountKey].value,myArgObj.myObj[constantsParams.firebaseAppURL].value,response);
     })
    .then(function() {
        myPrint.note("Upload to firebase realtime database completed successfully");
        return Promise.resolve();
    })
    .then(function() {
        myPrint.info("Done!");
    })
    .catch(function(err) {
        if (err) {
            myPrint.error("Something went terrible wrong here. See below for error details");
            console.log(err);
        }
        return Promise.reject();
    });
