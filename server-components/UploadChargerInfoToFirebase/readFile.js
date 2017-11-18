// jshint esversion:6, node:true, undef:true, unused:true 
//
//  Module readFile.js
//   - read file async operation. Returns a reslove-promise if no error detected, otherwise, reject-promise.
// 
// Parameters
//      param 1 - path to file to read 
//      param 2 - boolean paramter to indicate whether or not the input is subject to JSON.parse before returning the buffer.
//
//  HE - 23.09.2017  -> verified
//
//

var Promise = require('promise');
var fs = require('fs');
var read = Promise.denodeify(fs.readFile);

module.exports = function(filePath,parse) {
    var myPromise = read(filePath,'utf8')
        .then(function(str) {
            if (parse) {
                try {
                    JSON.parse(str);
                } catch (exception) {
                    return Promise.reject(exception + " in file: " +  filePath);
                }
                return Promise.resolve(JSON.parse(str));
            } else
                return Promise.resolve(str);
         })
        .catch (function(err) {
            return Promise.reject(err);
        });
    return myPromise;
};

