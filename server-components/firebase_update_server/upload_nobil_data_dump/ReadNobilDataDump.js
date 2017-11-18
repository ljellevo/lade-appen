// jshint esversion:5, node:true, undef:true, unused:true 
//
//  Module containing functions for read dump file from nobil database.
//
//  HE - 03.09.2017 
//
//

exports.readJSON=function(filePath,parse, callback) {
    var fs = require('fs');
    fs.readFile(filePath,'utf-8', function(err, data) {
        var parsedJson;
        if (err) {
            return callback(err);
        }
        if (parse) {
            try {
               parsedJson = JSON.parse(data);
            } catch (exception) {
                return callback(exception);
            }
            return callback(null, parsedJson);
        } else {
            return callback(null,data);
        }
    });
};

