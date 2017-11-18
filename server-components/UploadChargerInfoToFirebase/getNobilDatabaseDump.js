/* jshint esversion:6, node:true, undef:true, unused:true */
// 
// module getNobilDatabaseDump.js 
//
// parameters:
//    - url           <- url to NOBIL API search query
//    - queryObjFIle  <- file holding the REST query
// 
// return promise.resolve() if no error detected
// return promise.reject(err) when errer where detected.
//
// NOTE #1
// During implemntation we had problem using axios for posting the request.
// Ended up using plain search string in URL. 
// 
// NOTE #2
// Error handling based on size of returned data. Should maybe be modified to searching for word = error.
//
// 23.09.2017 -> verified.

'use strict';
var readFile = require('./readFile.js');
var Promise = require('promise');
var http = require('http');

var  getContent = function(url) {
    return new Promise((resolve,reject) => {
        var request = http.get(url, (response) => {
            if (response.statusCode < 200 || response.statusCode > 299) {
                reject(new Error(response.statusCode));
            }
            var body=[];
            response.on('data',(chunk) => body.push(chunk));
            response.on('end',() => { 
                if (body[0].length < 100) {
                    // return data less than 100 character indicate someting went terrible wrong
                    reject(body.join(''));
                } else {
                    resolve(body.join(''));
                }
            });
        });
        request.on('error', (err) => reject(err));
    });
};

var generateParamString = function(obj) {
    return new Promise((resolve,reject) => {
        var myString="?";
        Object.keys(obj).forEach(function(item) { 
            myString+=item+"="+obj[item];
            if (item != Object.keys(obj)[Object.keys(obj).length-1]) {
                myString+="&";
            }
        });
        resolve(myString);
    });
};


module.exports =  function(url,queryObjFile) { 
    var myPromise =  readFile(queryObjFile,true)
        .then(function(queryObj) {
            return generateParamString(queryObj);
        })
        .then(function(myParamString) {
            return getContent(url+myParamString);
        })
        .then(function(response) {
            return Promise.resolve(JSON.parse(response));
        })
        .catch(function(reject) {
                return Promise.reject(reject);
        });
    return myPromise;
};
