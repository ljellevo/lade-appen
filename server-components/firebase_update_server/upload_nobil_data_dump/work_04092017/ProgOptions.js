/* jshint esversion:5, node:true, undef:true, unused:true */

// Ini file holding default values.
// Function reading parameters support required value to parameter and parameters as switches. 
// A switch is indicated by igiven value=null, and the program will not look for value to option.
// NOTE: default values are given here.


exports.progOptions={
    "-d":{
        "option":"Save processed data to file",
        "value":"/tmp", 
        "set":false
    },
    "-u":{
        "option":"Whether or not to upload to firebase",
        "value":null,  
        "set":false    
    },
    "-i":{
        "option":"Name of file contianing datadump form NOBIL",
        "value":"nobil_db_dump", 
        "set":false
    },
    "-p":{
        "option":"Prefix for outpufiles.",
        "value":"ToFirebase_", 
        "set":false
    },
    "-h":{
        "option":"help - print out options",
        "value":null, 
        "set":false
    }
};
