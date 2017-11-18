// jshint esversion:5, node:true, undef:true, unused:true 
//
//  Module containing functions for write to file processed
//  dump from Nobil, ready to be uploaded to firebase.
//
//  HE - 03.09.2017 
//
//

exports.writeJSON=function(filePath,data,callback) {

    var parsedJson = JSON.stringify(data);

    var fs = require('fs');
    fs.writeFile(filePath,parsedJson,'utf-8', function(err, data) {
    //fs.writeFile(filePath,data,'utf-8', function(err, data) {
        if (err) {
            return callback(err);
        }
//        try {
//            parsedJson = JSON.parse(data);
//        } catch (exception) {
//            return callback(exception);
//        }
//        return callback(null, parsedJson);
        return callback(null);
    });
};

