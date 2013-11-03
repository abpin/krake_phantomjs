// This files is to be ran using PhantomJS

// Creation of web server
var server = require('webserver').create();
var KSON = require('./node_modules/kson/lib/kson');
var KrakeProcessor = require('./helpers/krake_processor');

// @Description : catchs and displays the error
phantom.onError = function(msg, trace) {
  var msgStack = ['PHANTOM ERROR: ' + msg];
  if (trace && trace.length) {
      msgStack.push('TRACE:');
      trace.forEach(function(t) {
          msgStack.push(' -> ' + (t.file || t.sourceURL) + ': ' + t.line + (t.function ? ' (in function ' + t.function + ')' : ''));
      });
  }
  console.error(msgStack.join('\n'));
  phantom.exit(1);
};

// @Description : extracts the columns from the page
// @param : krakeQueryObject:Object
// @param : callback:function
//    status:string - success || error
//    results:Object
var processPage = function(krakeQueryObject, callback) {
  
  if(!krakeQueryObject.origin_url ) {
    console.log('[PHANTOM_SERVER] origin_url not defined for \r\n\t\tURL:' + krakeQueryObject.origin_url);
    callback && callback('error', 'origin_url not defined');
    return;
    
  } else if(!krakeQueryObject.columns) {
    console.log('[PHANTOM_SERVER] columns not defined \r\n\t\tURL:' + krakeQueryObject.origin_url);
    callback && callback('error', 'columns not defined');
    return;    
    
  } else {
    console.log('[PHANTOM_SERVER] Processing page \r\n\t\tURL:' + krakeQueryObject.origin_url);
    var page = require('webpage').create();
    
    console.log('[PHANTOM_SERVER] Adding Middle Wares \r\n\t\tURL:' + krakeQueryObject.origin_url);
    kp = new KrakeProcessor();
    kp.use(require('./middlewares/set_headers'));
    kp.use(require('./middlewares/set_cookies'));
    kp.use(require('./middlewares/open_page'));
    kp.use(require('./middlewares/setup_json'));
    kp.use(require('./middlewares/include_jquery'));
    kp.use(require('./middlewares/waitup'));
    kp.use(require('./middlewares/extract_dom_elements'));       
    
    kp.process(page, krakeQueryObject, function(status, results) {
      callback && callback(status, results);
    });
    
  }
  
};

// The webserver
var service = server.listen(9701, function(req, res) {
  
  // Default route for testing purposes 
  if(req.url == '/') {
    res.statusCode = 200;
    res.write('I am Krake');
    res.close();
  
  // The actual route that Krake request will hit
  } else {
    
    var response = {}
    
    try {
      req.post = decodeURIComponent(req.post);
      var krakeQueryObject = KSON.parse(req.post);
      processPage(krakeQueryObject, function(status, results) {
        response.status = status;
        response.message = results;
        res.write(JSON.stringify(response));
        res.close();

      });
      
    } catch (e) {
      response.status = 'error';
      response.message = 'cannot render Krake query object, ' + e;
      res.write(JSON.stringify(response));
      res.close();      
      
    }
  }

});

console.log('Running phantom webserver at port : ', server.port);