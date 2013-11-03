// @Description : Given a page object sets the cookies for this object
// @param : page:object
// @param : cookies:array[]
var setCookies = function(page, krakeQueryObject, next) {
  
  if(krakeQueryObject.cookies) {
    for( x = 0; x < krakeQueryObject.cookies.length; x++) {
      add_results = phantom.addCookie({
        name : krakeQueryObject.cookies[x].name, 
        value : krakeQueryObject.cookies[x].value, 
        domain : krakeQueryObject.cookies[x].domain 
      });      
    };    
  }
  next();
  
};

var exports = module.exports = setCookies;