/* jshint esversion:6, node:true, undef:true, unused:true */
//
// 
// Module parseArguments.js 
// Handling commandline arguments and program options.
//
// Return promise:
//      promise.reject(errObject)
//          -> if any unexpected paramters found in argument list
//          -> errObject hold only the first detected argument
//      promise.resolve(reponse)
//          -> completed program options object updated with values given on commandline is returned.
//          -> if -h (help) is detected, returnvalue=null
//
// 23.09.2017 -> verified
//

'use strict';

var Promise = require('promise');
var myError=false;
var myErrObj={};
var jump=false;

function isParamOption(progOptions,param) {
    var ret=false;
    if (param[0] === '-') {
        if (progOptions=== null) {
            ret=true;
        } else {
            if (Object.keys(progOptions).indexOf(param) >= 0) { //option key known
                ret=true;
            }
        }    
    } 
    return ret;
}

function isParamHelp(myArgs,param) {
    var ret=false;
    Object.keys(myArgs).forEach(function(item) {
        if (myArgs[item] === param) {
            ret=true;
        } 
    });
    return ret;
}

function hasParamValue(myArgs,paramIndex) {
    var ret=false;
    if (((myArgs.length)-1) > (paramIndex)) {
        ++paramIndex;
        //may parameter in next 
        if (!isParamOption(null,myArgs[paramIndex])) { // parameter found (not option)
            ret=true;
           }
    }
    return ret;
}

module.exports=function(myOptions,myArg) {
    if (isParamHelp(myArg,"-h")) {
        return Promise.resolve(null);
    }

    Object.keys(myArg).forEach(function(i) {
        if ((!jump) && (!myError)) {
            if (isParamOption(myOptions,myArg[i])) {
              //  if (myOptions[myArg[i]]["value"] != null) { // switch option no need to look for values
                if (myOptions[myArg[i]].value != null) { // switch option no need to look for values
                    if (hasParamValue(myArg,i)) {
                        myOptions[myArg[i]].set=true;
                        myOptions[myArg[i]].value=myArg[++i];
                        jump=true;
                    } else {
                        myError=true;
                        myErrObj.key=myArg[i];
                        myErrObj.value="expected parameter value not given in argument list";
                    }

                } else {
                    myOptions[myArg[i]].set=true;
                }  
            } else {
                myError=true;
                myErrObj.key=myArg[i];
                myErrObj.value="Unknown option";
            }
        } else {
            jump = false;
        }

    });
    if (myError) {
        return Promise.reject(myErrObj);
    } else {
        return Promise.resolve(myOptions);
    }
};

