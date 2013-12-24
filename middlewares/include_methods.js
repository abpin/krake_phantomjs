var includeMethods = function(page, krakeQueryObject, next) {
  page.injectJs("./3p/extract_dom_attributes.js") && console.log('[PHANTOM_SERVER] included extractAttributeFromDom');
  next();
}
var exports = module.exports = includeMethods;