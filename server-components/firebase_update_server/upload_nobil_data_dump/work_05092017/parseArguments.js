/* jshint esversion:5, node:true, undef:true, unused:true */

// Module reading commandline agruments.
// Support both parameters required value and parameters as switches. 
// A switch is indicated by igiven value=null, and the program will not look for value to option.
// NOTE: default values are at present defined here.
// Shoud be however moved to main program


// the slice command below should be set in main program.
// var myargs=process.argv.slice(2);




function Arguments(ProgOptions) {
    this.myObj = {};

}

Arguments.prototype.init = function(progOption) {
    this.myObj = progOption;
};

//Arguments.prototype.parse = function(myArgs,myProgOptions,callback) {
Arguments.prototype.parse = function(myArgs,callback) {

    function myGetParameter(arg, index, value, callback) {
        var _myOpt=new Object;
        var _param=arg[index];
        _myOpt.set=true;
        if (value != null) {
            if (++index <= ((arg.length)-1)) {
                if (arg[index].indexOf("-") > -1 ){
                    return callback(1,2,_param +" -> value missing");
                } else {
                    _myOpt.value = arg[index];
                }
            }
            else {
                return callback(1,2,_param + " -> value missing");
            }
        } else {
            _myOpt.value = null;
            return callback(null,1,_myOpt);
        }
        return callback(null,2,_myOpt);
    }

    var i = 0;
    var myNext=0;
    var self=this.myObj;
    while (i < (myArgs.length)) {
//        if (Object.keys(myProgOptions).indexOf(myArgs[i]) >= 0) {
        if (Object.keys(self).indexOf(myArgs[i]) >= 0) {
            //myGetParameter(myArgs,i,myProgOptions[myArgs[i]].value,function(err,next,data) {
            myGetParameter(myArgs,i,this.myObj[myArgs[i]].value,function(err,next,data) {
                myNext=next;
                if (err) {
                    return callback(1,data);
                }
                self[myArgs[i]].value = data.value;
                self[myArgs[i]].set = data.set;
            });
            i+=myNext;
        } else {
            return callback(1,myArgs[i] + " -> unknown option");
        }
    }

//    for (var j in myProgOptions) {
//        if (myProgOptions[j].set) {
//            if (myProgOptions[j].value == null) {
//                return callback(1,myProgOptions[j].option + " not specified");
//            }
//        }
//    }
//    this.myObj=self;
    return callback(null,this.myObj);
};
            
Arguments.prototype.print = function() {
    console.dir(this.myObj , {depth: 3, colors: true});
}

//if (myargs) {
//    myCheckArguments(myargs, function(err, data) {
//        if (err) {
//            console.log(" ==> Invalid argumentlist: "  + data);
//        }
//    });
//}
//console.log(myProgOptions);
//
module.exports = Arguments;
