/* jshint esversion:6, node:true, undef:true, unused:true */
//
// Module printConsole.js
//
//
// Object class to handle colorizrd output console print.
//
// How to use:
//      initialize object with colorscheme as paramter
// implemented methods:
//      print.info(text)
//      print.note(text)     
//      print.warning(text)     
//      print.error(text)     
//
// colorschemas:
//      csDefault
//      cdHighLight
//      csColor
//      csFavorite
//      csDefault
//
// 23.09.2017 -> verified
//


function printConsole(cs) {
    if (cs===null) {
        this.cs="csDefault";
    } else {
        this.cs=cs;
    }
    this.esc = "\x1b[";
    this.colors = {
        "reset" : this.esc + "0m",
        "bright" : this.esc + "1m",
        "dim" : this.esc + "2m",
        "underscore" : this.esc + "4m",
        "blink" : this.esc + "5m",
        "reverse" : this.esc + "7m",
        "hidden" : this.esc + "8m",
        "fgBlack" : this.esc + "30m",
        "fgRed" : this.esc + "31m",
        "fgGreen" : this.esc + "32m",
        "fgYellow" : this.esc + "33m",
        "fgBlue" : this.esc + "34m",
        "fgMagenta" : this.esc + "35m",
        "fgCyan" : this.esc + "36m",
        "fgWhite" : this.esc + "37m",
        "fgLightCyan" : this.esc + "38m",
        "bgBlack" : this.esc + "40m",
        "bgRed" : this.esc + "41m",
        "bgGreen" : this.esc + "42m",
        "bgYellow" : this.esc + "43m",
        "bgBlue" : this.esc + "44m",
        "bgMagenta" : this.esc + "45m",
        "bgCyan" : this.esc + "46m",
        "bgWhite" : this.esc + "47m",
    };
    this.ColorSchemas = { 
        "csDefault" : {
            info : this.colors.fgWhite,
            note: this.colors.bright+this.colors.fgWhite,
            warning: this.colors.bright+this.colors.fgYellow,
            error: this.colors.fgRed,
            highlight: this.colors.fgGreen
            },
        "csHighLight" : {
            info: this.colors.bright+this.colors.fgGreen,
            note: this.colors.bright+this.colors.fgLightCyan,
            warning: this.colors.bright+this.colors.fgWhite,
            error: this.colors.bright+this.colors.fgRed,
            highlight: this.colors.fgYellow
        },
        "csColor" : {
            info: this.colors.fgGreen,
            note: this.colors.bright+this.colors.fgBlue,
            warning: this.colors.bright+this.colors.fgYellow,
            error: this.colors.fgRed,
            highlight: this.colors.fgBlue
        },
        "csFavorite" : {
            info: this.colors.fgWhite,
            note: this.colors.bright+this.colors.fgLightCyan,
            warning: this.colors.bright+this.colors.fgYellow,
            error: this.colors.fgRed,
            highlight: this.colors.fgBlue
        }
    };
   this.colorReset=this.colors.reset; 
}

printConsole.prototype.warning = function(text) {
var codeObj={"key" : "Warning","value" : "warning"};
    this.print(codeObj,text);
};


printConsole.prototype.note = function(text) {
var codeObj={"key" : "Note","value" : "note"};
    this.print(codeObj,text);
};


printConsole.prototype.info = function(text) {
var codeObj={"key" : "Info","value" : "info"};
    this.print(codeObj,text);
};


printConsole.prototype.error = function(text) {
var codeObj={"key" : "ERROR","value" : "error"};
    this.print(codeObj,text);
};

printConsole.prototype.print = function(codeObj,text) {
    var myStartText="==> ";
    var myLeadText= "";
    var myTextIndex="";
    myLeadText+=codeObj.key + ": ";
    myTextIndex=codeObj.value;
    text=text.replace(/\[/g,this.colors.reset+this.ColorSchemas[this.cs].highlight);
    text=text.replace(/\]/g,this.colors.reset+this.ColorSchemas[this.cs][myTextIndex]);
    console.log(this.colorReset + myStartText + this.ColorSchemas[this.cs][myTextIndex] + myLeadText + text + this.colorReset);
};



printConsole.prototype.printSchemas= function(text) {
    var myInitText="";
    var myText="";
    if (text) {
        myInitText=text + " - ColorSchema ";
    } else {
        myInitText="ColorSchema ";
    }
    for (var cs in this.ColorSchemas) {
        myText=myInitText + cs;
        for (var type in this.ColorSchemas[cs]) {
            console.log(this.ColorSchemas[cs][type] + myText + "(" +type+ this.colorReset+")");
        }
    }
};

module.exports = printConsole;

