/* jshint esversion:6, node:true, undef:true, unused:true */
//
// Module parseNnobilDatabaseDump.js
//
// Parameters:
//      data: Ouput from Nobil API call - in JSON format.
//
//  Return:
//      promise.resolve
//
//
// Parse output from chargerstation dumps from NOBIL api call and create database structures, ready to be uploaded to firebase realtime database 
//
// First - parse all received information, then creates indexes.
//
// Received data is structure into 2 differenst infornation objects. Thess objects are holded in different objectclasses;
//      - staticObject.js
//      - stationObject.js
//
// Object type #1 (stationsObject) - charger station information structure
// stastion_idx: {
//      "name" : "name",
//      "address" : "address"
//      ..
//      chargers: {
//          "01": {
//              "type": "type",
//              "connector": "connector",
//              "capacity": "capacity"
//              ...
//          }
//          ..
//
// Object type #2 (staticObject) - index structure 
// cities: {
//     station_id1: true,
//     station_id2: true,
// }
// counties: { 
//     station_id1: true,
//     station_id2: true,
// }
// municipalities: {
//     station_id1: true,
//     station_id2: true,
// }
//
//
// -> 16.09.2017 -> Starting convering to use promise in sted of callbacks.
// -> 23.09.2017 -> verified and completed 
//

"use strict";
var Promise=require('promise');
var staticObject = require('./staticObject.js');
var stationsObject = require('./stationsObject.js');
var readline = require('readline');

var myCities = new staticObject("cities");
var myCounties = new staticObject("counties");
var myMunicipalities = new staticObject("municipalities");
var mySubscriptions = new staticObject("subscriptions");
var myStations = new stationsObject("stations");
var myUnknown= new Object([]);
var myCounter =0;


module.exports =  function(data) { 
    return new Promise((resolve) => {
    Object.values(data.chargerstations).forEach(function(item) {
        myStations.add(item, function(err,myObj){
            if (!err) {
                readline.cursorTo(process.stdout, 0);
                myCounter++;
                myCities.add(item.csmd.Zipcode,item.csmd.International_id,true,item.csmd.City);  
                myCounties.add(item.csmd.County_ID, item.csmd.International_id,true,item.csmd.County);  
                myMunicipalities.add(item.csmd.Municipality_ID, item.csmd.International_id,true,item.csmd.Municipality);  
                mySubscriptions.add(item.csmd.International_id,"members","{}",null);
                process.stdout.write(`      Processing -> ${myObj}`);
            } else {
                myUnknown.push(myObj);
            }
        });
    });
    process.stdout.write(`..done\n`);
    resolve({myStations,myCounties,myMunicipalities,mySubscriptions,myCities});
});
};

