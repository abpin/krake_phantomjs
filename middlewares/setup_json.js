// @Description : Ensures JSON.parse method is always available
var setupJsonObject = function(page, krakeQueryObject, next) {
  var json_parse_exist = page.evaluate(function() {
    (typeof JSON != "object") && (JSON = {});
    return typeof JSON.parse == "function"
  }); 
  console.log('[PHANTOM_SERVER] JSON.parse exist? ' + json_parse_exist);
  !json_parse_exist && page.injectJs("./3p/json_parse.js") &&
    console.log('[PHANTOM_SERVER] Setup JSON.parse');
  
  next();
}

var exports = module.exports = setupJsonObject;