// @Description : the process that holds up the loading of pages
var waitUp = function(page, krakeQueryObject, next) {

  if(krakeQueryObject.wait && krakeQueryObject.wait > 0 ) {
    console.log('[PHANTOM_SERVER] : waiting for ' + krakeQueryObject.wait + ' milliseconds')
    setTimeout(function() {
      //extractDomElements();
      next();
    }, krakeQueryObject.wait);
  } else {
    //extractDomElements();
    next();
  }
}

var exports = module.exports = waitUp;