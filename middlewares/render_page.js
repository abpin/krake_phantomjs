// Does a screenshot of the current page
var renderPage = function(page, krakeQueryObject, next) {
  krakeQueryObject && krakeQueryObject.render && page.render('temp/screen-shot.pdf')
  next();
}

var exports = module.exports = renderPage;