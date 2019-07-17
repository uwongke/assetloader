let convert = require('xml-js');
let fs = require("fs");

let xml = require('fs').readFileSync('assets/test.xml', 'utf8');
let result = convert.xml2json(xml, {compact: true, spaces: 4});
fs.writeFileSync('assets/test.json', result, {flag: 'w'});
