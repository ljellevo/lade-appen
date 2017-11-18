/* jshint esversion:5, node:true, undef:true, unused:true */
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
/ * -> 30.08.2017 -> Complete test-upload to firebase db performed.
/ * -> 03.09.2017 -> Added cities, counties data structure ready to be uploaded to firebase
/ *
/ *  NOTE: build on 06_test_upload_tofirebase.js:
/*    SEE main.js !!
*/

"use strict";
var fs = require("fs");
var myObj = new Object;


function readJSON(filePath, callback) {
    fs.readFile(filePath,'utf-8', function(err, data) {
        var parsedJson;
        if (err) {
            return callback(err);
        }
        try {
            parsedJson = JSON.parse(data);
        } catch (exception) {
            return callback(exception);
        }
        return callback(null, parsedJson);
    });
}


function myStationsObject(key) {
    this.myKey = key;
    this.myData= new Object;

    this.ShowData = function(pretty) {
        var myObj={}
        myObj[this.myKey]=this.myData;
        if (pretty) {
            console.dir(myObj , {depth: 4, colors: true});
        } else {
            console.log(JSON.stringify(myObj));
        }
    }

    this.add = function(obj,callback) {
        var myObj = new Object;
        var tempObj = new Object;
        if (obj.csmd.International_id == null) { 
            return callback(1,obj.csmd.name);
        }
        var myVar=obj.csmd.International_id;
        myObj.name=obj.csmd.name;
        myObj.ContactInfo=obj.csmd.Contact_info
        myObj.Position=obj.csmd.Position
        myObj.Created=obj.csmd.Created
        myObj.City=obj.csmd.City
        myObj.OwnedBy=obj.csmd.Owned_by
        myObj.StationStatus=obj.csmd.Station_status
        myObj.Zipcode=obj.csmd.Zipcode
        myObj.Description_of_location=obj.csmd.Description_of_location
        myObj.UserComment=obj.csmd.User_comment
        myObj.id=obj.csmd.id
        myObj.Image=obj.csmd.Image
        myObj.Municipality=obj.csmd.Municipality
        myObj.Available_charging_points=obj.csmd.Available_charging_points
        myObj.LandCode=obj.csmd.Land_code
        myObj.name=obj.csmd.name
        myObj.County=obj.csmd.County
        myObj.Updated=obj.csmd.Updated
        myObj.CountyID=obj.csmd.County_ID
        myObj.InternationalID=obj.csmd.International_id
        myObj.HouseNumber=obj.csmd.House_number
        myObj.Street=obj.csmd.Street
        myObj.NumberCharging_points=obj.csmd.Number_charging_points
        myObj.MunicipalityID=obj.csmd.Municipality_ID

        for (var i in obj.attr.st) {
            switch (i) {
                case "2":
                    myObj.Availability=obj.attr.st[i].trans;
                    break;
                case "24":
                    myObj.Open24h=obj.attr.st[i].trans;
                    break;
                case "6":
                    myObj.TimeLimit=obj.attr.st[i].trans;
                    break;
                case "22":
                    myObj.PublicFunding=obj.attr.st[i].trans;
                    break;
                case "7":
                    myObj.ParkingFee=obj.attr.st[i].trans;
                    break;
                case "3":
                    myObj.Location=obj.attr.st[i].trans;
                    break;
                case "21":
                    myObj.RealtimeInfo=obj.attr.st[i].trans;
                    break;
            }
        }
        var myConn = new Object;
        var myallConn = new Object;
        for (var t in obj.attr.conn) {
            myConn={};
            for (var i in obj.attr.conn[t]) {
                switch (i) {
                    case "5":
                        myConn.Capacity=obj.attr.conn[t][i].trans;
                        break;
                    case "18":
                        myConn.Reservable=obj.attr.conn[t][i].trans;
                        break;
                    case "25":
                        myConn.FixedCable=obj.attr.conn[t][i].trans;
                        break;
                    case "23":
                        myConn.Manufacturer=obj.attr.conn[t][i].attrval;
                        break;
                    case "20":
                        myConn.ChargeMode=obj.attr.conn[t][i].trans;
                        break;
                    case "1":
                        myConn.Accessibility=obj.attr.conn[t][i].trans;
                        break;
                    case "4":
                        myConn.Connector=obj.attr.conn[t][i].trans;
                        break;
                    case "17":
                        myConn.Vehicle=obj.attr.conn[t][i].trans;
                        break;
                    case "10":
                        myConn.SensorStatus=obj.attr.conn[t][i].trans;
                        break;
                    case "9":
                        myConn.ErrorStatus=obj.attr.conn[t][i].trans;
                        break;
                    case "8":
                        myConn.Status=obj.attr.conn[t][i].trans;
                        break;
                    case "16":
                        myConn.Timestamp=obj.attr.conn[t][i].attrval;
                        break;
                    case "15":
                        myConn.LastUsage=obj.attr.conn[t][i].trans;
                        break;
                    case "20":
                        myConn.ChargeMode=obj.attr.conn[t][i].trans;
                        break;
                    case "19":
                        myConn.PaymentMethod=obj.attr.conn[t][i].trans;
                        break;
                }
            }     
            myallConn[t]=myConn;
        }
        myObj["conn"]=myallConn;
        this.myData[obj.csmd.International_id]=myObj
        return callback(null, obj.csmd.International_id);
    }
}



//var serviceAccont = require("../cert/serviceAccountKey.json");
//var firebaseAppURL="https://ladeappen.firebaseio.com";
//v//ar firebase = require("firebase-admin");
var readline = require('readline');

//firebase.initializeApp({
//	credential: firebase.credential.cert(serviceAccont),
//	databaseURL: firebaseAppURL
//});
//var db = firebase.database();
function myStaticObject(key) {
    this.key=key;
    this.data={};
    this.ShowData = function(pretty) {
        var myObj={}
        myObj[this.key]=this.data;
        if (pretty) {
            console.dir(myObj , {depth: 3, colors: true});
        } else {
            console.log(JSON.stringify(myObj));
        }
    }
    this.add = function(obj_key,key,value) {
        var myNewObj = new Object;
        var myObj = new Object;
        var myObjkey = obj_key.replace(/ /g,"_");
        myNewObj[key]=value;
        if (this.data[myObjkey]) {
            myObj=(this.data[myObjkey]);
            this.data[myObjkey]=Object.assign(myObj,myNewObj);
        } else {
            this.data[myObjkey]=myNewObj;
        }
    }
}

var myCities = new myStaticObject("Cities");
var myCounties = new myStaticObject("Conties");
var myMunicipality = new myStaticObject("Municipalities");
var myStations = new myStationsObject("Stations");
var myUnknown= [];
readJSON("my_db_dump", function(err, pkg) {
    if (!err) {
        for (var obj in pkg.chargerstations) {
            myStations.add(pkg.chargerstations[obj], function(err,myObj){
                if (!err) {
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
        console.log("\n ==> Reading chargerstations completed");
        for (var i in myUnknown) {
            console.log(" ==> NOTE: International ID not specified for [ %s ] - skipped", myUnknown[i]);
        }
//      myStations.ShowData(true);
    //  myCities.ShowData(true);
    //  myCounties.ShowData();
    //  myMunicipality.ShowData();
   //   db.ref("subscriptions").update(myObj);
    }
    else {
        console.log("Unable to parse inputfile. Aborting");
    }
});

// test program for evaluating command line argument list
// 03.09.0217
//  -> virker ganske bra
//  //

var myargs=process.argv.slice(2);

var myOptions= new Object;

myProgOptions={"-f":{"option":"Location of ini-file", "value":null,"set":false},"-d":{"option":"Just for testing","value":null,"set":false}};

function myCheckArguments(myArgs,callback) {
    function myGetParameter(arg, index, callback) {
        var myOpt=new Object;
        var param=arg[index];
        // console.log("param " + param);
        myOpt.set=true;
        if (++index <= ((arg.length)-1)) {
            if (arg[index].indexOf("-") > -1 ){
                return callback(1,param +" -> value missing");
            } else {
                myOpt.value = arg[index];
            }
        }
        else {
            return callback(1,param + " -> value missing");
        }
        return callback(null,myOpt);
    }

    var i = 0
    while (i < (myArgs.length)) {
        if (Object.keys(myProgOptions).indexOf(myArgs[i]) >= 0) {
            //myGetParameter(myArgs[i], myArgs,i,function(err,data) {
            myGetParameter(myArgs,i,function(err,data) {
                if (err) {
                    return callback(1,data);
                }
                myProgOptions[myArgs[i]].value = data.value;
                myProgOptions[myArgs[i]].set = data.set;
            });
            i+=2;
        } else {
            return callback(1,myArgs[i] + " -> unknown option");
        }
    }

    for (var j in myProgOptions) {
        if (myProgOptions[j].set) {
            if (myProgOptions[j].value == null) {
                return callback(1,myProgOptions[j].option + " not specified");
            }
        }
    }
    return callback(null,true);
}


myCheckArguments(myargs, function(err, data) {
    if (err) {
        console.log(" ==> Invalid argumentlist: "  + data);
    }
});

console.log(myProgOptions);
