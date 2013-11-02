// @Description : Given a page object sets the cookies for this object
// @param : page:object
// @param : cookies:array[]
var setCookies = function(page, krakeQueryObject, next) {
  console.log("[PHANTOM_SERVER] Setting Cookies");
  //console.log(phantom)
  if(krakeQueryObject.cookies) {
    for( x = 0; x < krakeQueryObject.cookies.length; x++) {
      add_results = phantom.addCookie({
        name : krakeQueryObject.cookies[x].name, 
        value : krakeQueryObject.cookies[x].value, 
        domain : krakeQueryObject.cookies[x].domain 
      });
      
      if(add_results) {
        console.log(
          '\r\n\t\tCookie was added ' + 
          '\r\n\t\t\tname : ' + krakeQueryObject.cookies[x].name + ' : ' + 
          '\r\n\t\t\tvalue : ' + krakeQueryObject.cookies[x].value + ' : ' + 
          '\r\n\t\t\tdomain : ' + krakeQueryObject.cookies[x].domain );
        
      } else {
        console.log(
          '\r\n\t\tCookie was not added' + 
          '\r\n\t\t\tname : ' + krakeQueryObject.cookies[x].name + ' : ' + 
          '\r\n\t\t\tvalue : ' + krakeQueryObject.cookies[x].value + ' : ' + 
          '\r\n\t\t\tdomain : ' + krakeQueryObject.cookies[x].domain );        
      }
      
    };    
  }
  next();
};

var exports = module.exports = setCookies;