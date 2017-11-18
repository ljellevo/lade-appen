/* jshint esversion:6, node:true, undef:true, unused:true */
// 
// module getProgArguments.js 
//
// Description:
// Module which build data structure (object) for program arguments and defeult values. 
// The structure is updated with arguments given as program options.
//
//
// parameters:
//    - optionFile     <- file holding program option in JSON format
//    - argObj         <- object holding programarguments, based on progOptionsObj.js class.
// 
// return promise.resolve() if no error detected
// return promise.reject(err) when errer where detected.
//
// 23.09.2017 -> verified
//

'use strict';

var readFile=require('./readFile.js');
var Promise=require('promise');
var myArgs=process.argv.slice(2);
var printConsole = require('./printConsole.js');
var myPrint = new printConsole("csFavorite");

module.exports = function(optionFile,myArgObj) { 
    var myPromise = readFile(optionFile,true)
        .then(function(data) {
            return myArgObj.init(data.progOptions,myArgs);
        })
        .then(function(data) {
            if (data===null) {
                return new Promise.reject();
            } else {
                return new Promise.resolve();
            }
        })
        .catch(function(reject) {
            if (reject != null) {
                myPrint.error(reject.key + "; " + reject.value);
                myArgObj.print(true,false);
            } else {
                myArgObj.print(true,true);
            }
            return new Promise.reject(null);
        });
    return myPromise;
};

