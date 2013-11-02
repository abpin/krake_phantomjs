var parseUri = require('../3p/parse_uri');

// @Description : checks the settings for current domain and determine if should set header
// @param : page:object
// @param : krakeQueryObject:Object
// @param : next:function()
var setHeaders = function(page, krakeQueryObject, next) {

  domain_info = parseUri(krakeQueryObject.origin_url);
  if(domain_info.host.match(/google.com/)) {
    page.settings['userAgent'] = 
      'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1';    
  }
  next();
}

var exports = module.exports = setHeaders;