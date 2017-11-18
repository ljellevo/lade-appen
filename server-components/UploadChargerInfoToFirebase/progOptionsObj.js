/* jshint esversion:5, node:true, undef:true, unused:true */
//
// Module progOptionsObj.js
//
// module holding object of program default values modified with commandline agruments  
// To initiate the object, the init-methods must be called first.
// Then the use the parse methods to update the structure with values from commandline. 
// program option "-h" is treated as help and will print out all program options in optionfile.
// In addition, the help will be trigged when:
//      a) required parametervalue is missing
//      b) given parameter unknown to the program
//      
// Support parameters with required value as well as parameters as switches. 
// A switch is indicated by given the value key null  - see below for example.
// The object parse programoptions in JSON format. 
//
// Format of program options:
// { 
//      "-o" : {
//              "option" : "description of the option",
//              "value" : "default value",        <- if switch, set value = null
//              "set" : false,                    <- allways false.
//             }
// }
//
//
// Module handling commandline arguments
// Return promise:
//      promise.reject(errObject)
//          -> if any unexpected found in argument list
//          -> errObject hold only the first detected argument
//      promise.resolve(reponse)
//          -> completed updated argumnts returned.
//          -> if -h (help) detected, return null
//
//
// 23.09.2017 -> verified
//

var Promise = require('promise');
var parseArguments = require('./parseArguments.js');

function Arguments() {
    this.myObj = {};
}

Arguments.prototype.init = function(progOptions,myArgs) {
    this.myObj = progOptions;
    var self=this.myObj;
    // save default values, just in case for the help message...
    Object.keys(self).forEach(function(item) {
        self[item].default=self[item].value;
    });
    var myPromise = parseArguments(progOptions,myArgs)
    .then(function(response) {
        return Promise.resolve(response);
    })
    .catch(function(reject) {
        return Promise.reject(reject);
    })
    return myPromise; 
};

Arguments.prototype.print = function(printHelp,printHeading) {
    if (printHelp) {
        if (printHeading) {
            console.log(this.myObj["-h"].option);
        }
        console.log("The program takes the following arguments:");
        for (var myParam in this.myObj) {
            if (myParam != "-h" ) {
                console.log("    " + myParam + ": " + this.myObj[myParam].option);
                if (this.myObj[myParam].value) {
                    console.log("        Default: [ "+ this.myObj[myParam].default + " ]");
                }
            }
        }
    } else {
        console.dir(this.myObj , {depth: 3, colors: true});
    }
};

Arguments.prototype.isSet = function(param) {
    if (this.myObj[param].set) {
        return true;
    } else {
        return false;
    }
};

module.exports = Arguments;



