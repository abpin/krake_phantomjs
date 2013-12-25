var fs = require('fs');

// Does a screenshot of the current page
var renderPage = function(page, krakeQueryObject, next) {
  krakeQueryObject && krakeQueryObject.render && page.render('temp/screen-shot.pdf');
  fs.write('temp/screen-capture.html', page.content, 'w');
  next();
}

var exports = module.exports = renderPage;