/* jshint esversion:6, node:true, undef:true, unused:true */
//
// nodejs script to print colorizrd output 
//
//
// 07.09.2017 - HE
//

const colorErrorIndex=1;
const colorNoteIndex=2;
const colorWarningIndex=3;
const colorHighlightIndex=4;
const colorInfoIndex=0;
const colorResetIndex=5;


function printConsole() {
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
            colorInfoIndex : this.colors.fgWhite,
            colorNoteIndex : this.colors.bright+this.colors.fgWhite,
            colorWarningIndex : this.colors.bright+this.colors.fgYellow,
            colorErrorIndex : this.colors.fgRed
            },
        "csHighLight" : {
            colorInfoIndex : this.colors.bright+this.colors.fgGreen,
            colorNoteIndex : this.colors.bright+this.colors.fgLightCyan,
            colorWarningIndex : this.colors.bright+this.colors.fgWhite,
            colorErrorIndex : this.colors.bright+this.colors.fgRed
        },
        "csColor" : {
            colorInfoIndex : this.colors.fgGreen,
            colorNoteIndex : this.colors.bright+this.colors.fgBlue,
            colorWarningIndex : this.colors.bright+this.colors.fgYellow,
            colorErrorIndex : this.colors.fgRed
        },
        "csFavorite" : {
            colorInfoIndex : this.colors.fgWhite,
            colorNoteIndex : this.colors.bright+this.colors.fgLightCyan,
            colorWarningIndex : this.colors.bright+this.colors.fgYellow,
            colorErrorIndex : this.colors.fgRed
        }
    };
   this.colorReset=this.colors.reset; 
}

printConsole.prototype.log = function(code,text,cs) {
    var myLeadText="==";
    switch (cs) {
        case "csHighLight":
            var myCs=this.ColorSchemas.csHighLight;
            break;
        case "csColor":
            var myCs=this.ColorSchemas.csColor;
            break;
        case "csFavorite":
            var myCs=this.ColorSchemas.csFavorite;
            break;
        default:
            var myCs=this.ColorSchemas.csDefault;
    };
    switch (code) {
        case "Error":
            myLeadText+= "! ERROR: ";
            myTextIndex="colorErrorIndex";
            break;
        case "Warning":
            myLeadText+="> Warning: ";
            myTextIndex="colorWarningIndex";
            break;
        case "Note":
            myLeadText+="> Note: ";
            myTextIndex="colorNoteIndex";
            break;
        default:
            myLeadText+="> Info: ";
            myTextIndex="colorInfoIndex";
    };
            
   console.log(this.colorReset + myCs[myTextIndex] + myLeadText + text + this.colorReset);
};

printConsole.prototype.printSchemas= function() {
    var myText="";
    for (var cs in this.ColorSchemas) {
        myText="Colorschema " + cs;
        for (var type in this.ColorSchemas[cs]) {
            console.log(this.ColorSchemas[cs][type] + myText + " -> " +type+ this.colorReset);
        }
    }
};

module.exports = printConsole;

