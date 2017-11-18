/* jshint esversion:5, node:true, undef:true, unused:true */

// Module reading commandline agruments.
// Support both parameters required value and parameters as switches. 
// A switch is indicated by igiven value=null, and the program will not look for value to option.
// NOTE: default values are at present defined here.
// Shoud be however moved to main program


// the slice command below should be set in main program.
// var myargs=process.argv.slice(2);


exports.GetArguments=function(myArgs,myProgOptions,callback) {
    function myGetParameter(arg, index, value, callback) {
        var myOpt=new Object;
        var param=arg[index];
        myOpt.set=true;
        if (value != null) {
            if (++index <= ((arg.length)-1)) {
                if (arg[index].indexOf("-") > -1 ){
                    return callback(1,2,param +" -> value missing");
                } else {
                    myOpt.value = arg[index];
                }
            }
            else {
                return callback(1,2,param + " -> value missing");
            }
        } else {
            myOpt.value = null;
            return callback(null,1,myOpt);
        }
        return callback(null,2,myOpt);
    }

    var i = 0;
    var myNext=0;
    while (i < (myArgs.length)) {
        if (Object.keys(myProgOptions).indexOf(myArgs[i]) >= 0) {
            myGetParameter(myArgs,i,myProgOptions[myArgs[i]].value,function(err,next,data) {
                myNext=next;
                if (err) {
                    return callback(1,data);
                }
                myProgOptions[myArgs[i]].value = data.value;
                myProgOptions[myArgs[i]].set = data.set;
            });
            i+=myNext
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
    return callback(null,myProgOptions);
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

