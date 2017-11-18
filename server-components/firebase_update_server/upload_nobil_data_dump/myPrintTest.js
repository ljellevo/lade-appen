var printConsole = require('./printConsole');
var myPrint = new printConsole();

//console.log(myPrint.colors.fgYellow);

//myPrint.log(1,"hei jalla","csDefault");
//myPrint.log(1,"hei jalla","csHighLight");
//myPrint.log(1,"hei jalla","csColor");
//myPrint.log(1,"hei jalla","csFavorite");
//myPrint.log(1,"hei jalla","csDefault");
//
myPrint.printSchemas();

var cs="csFavorite";
myPrint.log("Info","shoud be info",cs);
myPrint.log("Note","shoud be note",cs);
myPrint.log("Warning","shoud be warning",cs);
myPrint.log("Error","shoud be error",cs);
