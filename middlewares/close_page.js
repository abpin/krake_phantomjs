var closePage = function(page, krakeQueryObject, next) {
  console.log('[PHANTOM_SERVER] closed page\r\n\r\n\r\n');  
  page.close();
  next();  
}

var exports = module.exports = closePage;  