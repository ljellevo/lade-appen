/* jshint esversion:5, node:true, undef:true, unused:true */

// Module reading commandline agruments.
// Support both parameters required value and parameters as switches. 
// A switch is indicated by igiven value=null, and the program will not look for value to option.
// NOTE: default values are at present defined here.
// Shoud be however moved to main program


// the slice command below should be set in main program.
// var myargs=process.argv.slice(2);


function Arguments() {
    this.myObj = {};
}

Arguments.prototype.init = function(progOption) {
    this.myObj = progOption;
};

Arguments.prototype.parse = function(myArgs,callback) {
    
    function myGetParameter(arg, index, value, callback) {
        var _myOpt={};
        var _param=arg[index];
        _myOpt.set=true;
        if (value != null) {
            if (++index <= ((arg.length)-1)) {
                if (arg[index].indexOf("-") > -1 ){
                    return callback(_param +" -> value missing",2,null);
                } else {
                    _myOpt.value = arg[index];
                }
            }
            else {
                return callback(_param + " -> value missing",2,null);
            }
        } else {
            _myOpt.value = null;
            return callback(null,1,_myOpt);
        }
        return callback(null,2,_myOpt);
    }

    var i = 0;
    var self=this.myObj;
    var myErrCode=null;
    var myNext=0;
    var argHelp=false;
    while (i < (myArgs.length)) {
        if (Object.keys(self).indexOf(myArgs[i]) >= 0) {
            myGetParameter(myArgs,i,self[myArgs[i]].value,function(err,next,data) {
                myNext=next;
                if (err) {
                    myErrCode=err;
                } else {
                    if (myArgs[i] == "-h") {
                        argHelp=true;
                        myErrCode="help";
                    } else {
                        self[myArgs[i]].value = data.value;
                        self[myArgs[i]].set = data.set;
                    }
                }
            });
            i+=myNext;
        } else {
            myErrCode=myArgs[i] + " -> unknown option";
            i++;
        }
    }
     return callback(myErrCode,null,argHelp);
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
            }
        }
    } else {
        console.dir(this.myObj , {depth: 3, colors: true});
    }
};

module.exports = Arguments;
