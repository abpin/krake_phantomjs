// Clicks on the elements on the page
var clickElements = function(page, krakeQueryObject, next) {

  //page.render('facebook-phantom.pdf');
  console.log('[PHANTOM_SERVER] clicking elements on page');

  page.evaluate(function(krakeQueryObject) {
    if(krakeQueryObject && krakeQueryObject.to_click) {
      krakeQueryObject.to_click.forEach(function(value) { 
        jQuery(value).trigger('click');
      });
    }

  }, krakeQueryObject); // eo evaluation  

  next();
}

var exports = module.exports = clickElements;