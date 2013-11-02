
// @Description : determines if jQuery is to be included dynamically during run time
var includeJquery = function(page, krakeQueryObject, next) {
  
  if(krakeQueryObject.exclude_jquery) {
    console.log('[PHANTOM_SERVER] jQuery was excluded');
    
  } else {
    // checks if jQuery is already included
    var jquery_exist = page.evaluate(function() {
      return (typeof jQuery == "function");
    });
   
    jquery_exist && console.log("[PHANTOM_SERVER] jQuery library already exist");
    !jquery_exist && page.injectJs("./3p/jquery.js") &&
      console.log('[PHANTOM_SERVER] jQuery was injected');

  }    

  next();  
}  

var exports = module.exports = includeJquery;