/* jshint esversion:6, node:true, undef:true, unused:true */
//
//  Module uploadToFirebase - uploads data to firebase database. Returns a reslove-promise if no error detected, otherwise, reject-promise.
//  Use previously created firebase service account for authentication with database service.
//
//  Parameters:
//       certServiceAccount  -> certificate file (json) holding the credentials for service account (received after creation of service account)
//       firebaseAppURL      -> URL for firebase application
//       dataObject          -> Object holding data to be uploaded:
//                                  { key: dataIndex, data: {dataStructure data}, databaseStructure2: {dataStructure data}, databaseStructure3: {dataStructure data}}
//                              NOTE: dataStructure must be give in in key/value format i.e {"key1" : "foo", "key2": "bar"}.
//
//  HE - 17.09.2017 -> in progress
//
//

"use strict";
var Promise = require('promise');
// var firebase = require("firebase-admin");

function UploadProcess(certServiceAccount,firebaseAppURL,dataObject,db) {
    var myPromises=[];
    Object.keys(dataObject).forEach(function(index) {
        myPromises.push(new Promise(function(resolve,reject) { 
            db.ref(dataObject[index].key).update(dataObject[index].data)
                .then(function() {
                    resolve(index); 
                })
                .catch(function() {
                    reject(index);
                });
        }));
    });
    return Promise.all(myPromises); 
}   

module.exports = function(certServiceAccount,firebaseAppURL,dataObject) {
    var firebase = require("firebase-admin");
    firebase.initializeApp({
        credential: firebase.credential.cert(certServiceAccount),
        databaseURL: firebaseAppURL
    });
    var db = firebase.database();
    var myPromise = UploadProcess(certServiceAccount,firebaseAppURL,dataObject,db) 
        .then(function() {
            return new Promise.resolve();
        })
        .then(function() {
            // closing database connection
            db.app.delete();
        })
        .catch(function() {
            db.app.delete();
            return new Promise.reject();
        });
    return myPromise;
};
