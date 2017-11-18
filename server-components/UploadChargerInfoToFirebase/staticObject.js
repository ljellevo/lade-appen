// jshint esversion:5, node:true, undef:true, unused:true 
// Module - handling datastrunctures.
// script to read output from db_dump api call from NOBIL database and write to
// database structure in firebase:
//
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
// -> 29.08.2017 -> Completed read from file, parse and datastructure.
// -> 30.08.2017 -> Complete test-upload to firebase db performed.
// -> 03.09.2017 -> Added cities, counties data structure ready to be uploaded to firebase
// -> 23.09.2017 -> Verified
// 'use strict';

function staticObject(key) {
    var self = this;
    self.key=key;
    //self.data={"index":{}},{};
    self.data={"index":{}};
}

staticObject.prototype.ShowData = function(pretty) {
    var self = this;
        var myObj={};
        myObj[self.key]=this.data;
        if (pretty) {
            console.dir(myObj , {depth: 3, colors: true});
        } else {
            console.log(JSON.stringify(myObj));
        }
};

staticObject.prototype.add = function(obj_key,key,value,indexValue) {
        var self = this;
        var myNewObj = {};
        var myObj = {};
        var myObjkey = obj_key.replace(/ |\./g,"_");
        myNewObj[key]=value;
        if (!self.data.index[obj_key]) {
            self.data.index[obj_key]=indexValue;
        }
        if (self.data[myObjkey]) {
            myObj=(self.data[myObjkey]);
            self.data[myObjkey]=Object.assign(myObj,myNewObj);
        } else {
            self.data[myObjkey]=myNewObj;
        }
};

module.exports = staticObject;

