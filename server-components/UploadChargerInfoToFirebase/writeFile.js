// jshint esversion:5, node:true, undef:true, unused:true 
//
//  Module containing function for async write of data to file. Returns a resolve-promise f successfyll, otherwise, reject-promise.
//  Takes path, file, data and boolean parameter to instruct whether or not to run JSON.Stringfy on the data before writing to file. 
//
//  HE - 12.09.2017 
//
//
//

var Promise = require('promise');
var fs = require('fs');
var write = Promise.denodeify(fs.writeFile);
var mkdir = Promise.denodeify(fs.mkdir);

module.exports = function writeFile(path,file,data,json_stringify) {
    var dataBuffer;
    if (json_stringify) {
        dataBuffer = JSON.stringify(data);
    } else {
        dataBuffer=data;
    }
    var myPromise = mkdir(path,'0774')
        .then(function() {
            return myFileWrite(path+"/"+file,dataBuffer);
        })
        .catch(function(err) {
            if (err.code == "EEXIST") {
                return myFileWrite(path+"/"+file,dataBuffer);
            } else{
                return Promise.reject(err);
            }
        });
    return myPromise;
};


function myFileWrite(file,data) {
    var myPromise = write(file,data)
        .then(function() {
            return Promise.resolve(file);
        })
        .catch(function(error){
            return Promise.reject(error);
        });
   return myPromise;
}

