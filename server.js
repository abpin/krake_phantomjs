// This files is to be ran using PhantomJS

// Creation of web server
var server = require('webserver').create();
var parseUri = require('./3p/parse_uri');
var KSON = require('./node_modules/kson/lib/kson');


// @Description : checks the settings for current domain and determine if should set header
// @param : page_url:String
// @return : settings:Object
//    setHeader
//    setCookie
var getDomainSettings = function(page_url) {
  var settings = {
    set_header : false,
    set_cookie : true
  }
  
  var domain_info = parseUri(page_url);
  domain_info.host.match(/facebook.com/) && (settings.set_header = false);
  domain_info.host.match(/google.com/) && (settings.set_header = true);  
  return settings;
}


// @Description : Given a page object sets the header for this object
// @param : page:object
var setDefaultHeader = function(page) {
  console.log("[PHANTOM_SERVER] Setting user agent headers");
  page.settings['userAgent'] = 
    'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1';
  return page;
  
};



// @Description : Opens the page, extracts the data and returns the response
// @param : page:Object
// @param : krake_query_obj:Object
// @param : callback:function
//    status:String
//    results:Object
//        result_rows:Array
//          result_row:Object
//            attribute1:String value1 - based on required_attribute
//            attribute2:String value2 - based on required_attribute
//            ...
//        next_page:String — value to next page href
var openPage = function(page, krake_query_obj, callback) {
  console.log("[PHANTOM_SERVER] Opening page");

  var results = {};
  
  // @extracts the DOM elements from the page  
  var extractDomElements = function() {
    
    //page.render('facebook-phantom.pdf');
  	console.log('[PHANTOM_SERVER] extracting DOM elements');

    // @Description : extracts value from page
    // @return: 
    //    results:Object
    //        result_rows:Array
    //          result_row:Object
    //            attribute1:String value1 - based on required_attribute
    //            attribute2:String value2 - based on required_attribute
    //            ...
    //        next_page:String — value to next page href
    //        logs:Array
    //          log_mesage1:String, ...
    results = page.evaluate(function(krake_query_obj) {

      var results = {};
      results.logs = [];
      results.result_rows = [];

      // Gets the value of a DOM attribute
      var extractAttributeFromDom = function(dom_obj, required_attribute) {

        var return_val = '';

        switch(required_attribute) {
          case 'href'       :
          case 'src'        :
            return_val = dom_obj[required_attribute];
            break;

          case 'innerHTML'  : 
            return_val = dom_obj.innerHTML;
            break;

          case 'innerText'  :
          case 'textContent':
          case 'address'    :
          case 'email'      :
          case 'phone'      :
            return_val = dom_obj.textContent || dom_obj.innerText;
            break;

          default : 
            return_val = required_attribute && dom_obj.getAttribute(required_attribute)
            !return_val && (return_val = dom_obj.textContent)
        }

        return return_val && return_val.trim() || ''

      }

      // Goes through each columns
      for(var x = 0; x < krake_query_obj.columns.length ; x++) {
        
        var curr_column = krake_query_obj.columns[x];
        
        // when jQuery selector is to be used        
        if( (typeof jQuery == "function") && curr_column.dom_query) {
          results.logs.push("[PHANTOM_SERVER] extract using jQuery" + 
            "\r\n\t\tcol_name:" + curr_column.col_name +
            "\r\n\t\tdom_query:" + curr_column.dom_query);
          
          if(!curr_column.is_compound) {
            var jquery_results = jQuery(curr_column.dom_query);
            for (var y = 0; y < jquery_results.length ; y++ ) {
              var curr_result_row = results.result_rows[y] || {};
              curr_result_row[curr_column['col_name']] = extractAttributeFromDom(jquery_results[y], curr_column['required_attribute']);
              results.result_rows[y] = curr_result_row;
            }
            
          } else {
            var jquery_results = [];
            jQuery(curr_column.dom_query).map(function(index, item) {
              jquery_results.push(extractAttributeFromDom(item, curr_column['required_attribute']));
            });
            var curr_result_row = results.result_rows[0] || {};
            curr_result_row[curr_column['col_name']] = jquery_results.join();
            results.result_rows[0] = curr_result_row;
            
          }
        
        // when jQuery has been explicitly excluded
        } else if( (typeof jQuery != "function") && curr_column.dom_query) {
          results.logs.push("[PHANTOM_SERVER] extract using CSS Selector" + 
            "\r\n\t\tcol_name:" + curr_column.col_name +
            "\r\n\t\tdom_query:" + curr_column.dom_query);
            
          if(!curr_column.is_compound) {
            var query_results = document.querySelectorAll(curr_column.dom_query);
            for (var y = 0; y < query_results.length ; y++ ) {
              var curr_result_row = results.result_rows[y] || {};
              curr_result_row[curr_column['col_name']] = extractAttributeFromDom(query_results[y], curr_column['required_attribute']);
              results.result_rows[y] = curr_result_row;
            }
            
          } else {
            var query_results = document.querySelectorAll(curr_column.dom_query);
            var final_results = [];
            for (var y = 0; y < query_results.length ; y++ ) {
              final_results.push(extractAttributeFromDom(query_results[y], curr_column['required_attribute']));
            }
            var curr_result_row = results.result_rows[0] || {};
            curr_result_row[curr_column['col_name']] = final_results.join();
            results.result_rows[0] = curr_result_row;
                    
          }

        // when xpath is to be used
        } else if(curr_column.xpath) {

          results.logs.push("[PHANTOM_SERVER] extract using Xpath" + 
            "\r\n\t\tcol_name:" + curr_column.col_name +
            "\r\n\t\tdom_query:" + curr_column.xpath );

          var xPathResults = document.evaluate(curr_column.xpath, document);  
          var curr_item;
          var y = 0;
          
          if(!curr_column.is_compound) {
            while(curr_item = xPathResults.iterateNext()) {
              var curr_result_row = results.result_rows[y] || {}; 
              curr_result_row[ curr_column['col_name'] ] = extractAttributeFromDom(curr_item, curr_column['required_attribute']);
              results.result_rows[y] = curr_result_row;
              y++;
            }
            
          } else {
            var final_results = [];
            while(curr_item = xPathResults.iterateNext()) {
              final_results.push(extractAttributeFromDom(curr_item, curr_column['required_attribute']));
            }
            var curr_result_row = results.result_rows[0] || {};
            curr_result_row[curr_column['col_name']] = final_results.join();
            results.result_rows[0] = curr_result_row;  
            
          }
          
        // when both xpath and dom_query are missing
        } else {
          results.logs.push("[PHANTOM_SERVER] dom selector is missing" + 
            "\r\n\t\col_name:" + curr_column['col_name']);
          
        }

        
      } // eo iterating through krake columns
      
      
      
      // gets the next page hyperlink if it exist and use Xpath
      if(krake_query_obj.next_page && krake_query_obj.next_page.xpath) { 
        results.logs.push("[PHANTOM_SERVER] extracting next page using Xpath" + 
            "\r\n\t\txpath : " + krake_query_obj.next_page.xpath);
        var xPathResults = document.evaluate(krake_query_obj.next_page.xpath, document);  
        var xpath_np;
        while(xpath_np = xPathResults.iterateNext()) {
           results.next_page = xpath_np.getAttribute('href');
        }        
      
      // when jQuery selector is to be used             
      } else if( (typeof jQuery == "function") && krake_query_obj.next_page && krake_query_obj.next_page.dom_query) {
        results.logs.push("[PHANTOM_SERVER] extracting next page using jQuery" + 
            "\r\n\t\tdom_query : " + krake_query_obj.next_page.dom_query);
        var jquery_np = jQuery(krake_query_obj.next_page.dom_query);
        jquery_np.length && ( results.next_page = extractAttributeFromDom(jquery_np[0], 'href') );
        
      // when jQuery has been explicitly excluded
      } else if(  (typeof jQuery != "function") && krake_query_obj.next_page && krake_query_obj.next_page.dom_query) {
        results.logs.push("[PHANTOM_SERVER] extracting next page using jQuery" + 
            "\r\n\t\tdom_query : " + krake_query_obj.next_page.dom_query);
        var jquery_np = document.querySelectorAll(krake_query_obj.next_page.dom_query);
        jquery_np.length && ( results.next_page = extractAttributeFromDom(jquery_np[0], 'href' ) );
      
      }      

      return results;
        
    }, krake_query_obj); // eo evaluation
    console.log('[PHANTOM_SERVER] Extraction finished.');
    console.log('[PHANTOM_SERVER] Query');    
    console.log(JSON.stringify(krake_query_obj) + '\r\n\r\n');
    console.log('[PHANTOM_SERVER] result');        
    console.log(JSON.stringify(results) + '\r\n\r\n');
    callback('success', results);
    page.close();
  }

  // @Description : the process that holds up the loading of pages
  var waitUp = function() {

    if(krake_query_obj.wait && krake_query_obj.wait > 0 ) {
      console.log('[PHANTOM_SERVER] : waiting for ' + krake_query_obj.wait + ' milliseconds')
      setTimeout(function() {
        extractDomElements();

      }, krake_query_obj.wait);
    } else {
      extractDomElements();

    }
  }
  
  
  // @Description : Ensures JSON.parse method is always available
  var setupJsonObject = function() {
    var json_parse_exist = page.evaluate(function() {
      (typeof JSON != "object") && (JSON = {});
      return typeof JSON.parse == "function"
    }); 
    console.log('[PHANTOM_SERVER] JSON.parse exist? ' + json_parse_exist);
    !json_parse_exist && page.injectJs("./3p/json_parse.js") &&
      console.log('[PHANTOM_SERVER] Setup JSON.parse');
  }
  
  
  
  // @Description : determines if jQuery is to be included dynamically during run time
  var includeJquery = function() {
    
    if(krake_query_obj.exclude_jquery) {
      console.log('[PHANTOM_SERVER] jQuery was excluded');
      waitUp();  
      
    } else {
      // checks if jQuery is already included
      var jquery_exist = page.evaluate(function() {
        return (typeof jQuery == "function");
      });
     
      jquery_exist && console.log("[PHANTOM_SERVER] jQuery library already exist");
      !jquery_exist && page.injectJs("./3p/jquery.js") &&
        console.log('[PHANTOM_SERVER] jQuery was injected');
      waitUp();      
    }    
	  
  }  
  
  // @Description : the process that handles the finished loading of pages
  /*
  page.onLoadFinished = function(status) {
    // When opening page failed
  	if(status !== 'success') {
  	  console.log('[PHANTOM_SERVER] page failed to finish loading.');
      callback('error', 'page failed to finish loading');
      page.close();

    // when opening page was successful  		
  	} 
  }*/
  
  // @Description : throws up the error
  page.onError = function (msg, trace) {
    console.log(msg);
    trace.forEach(function(item) {
        console.log('  ', item.file, ':', item.line);
    })
  };
  
  // @Description : opens the page
  page.open(krake_query_obj.origin_url, function(status) {
    
    // When opening page failed
  	if(status !== 'success') {
  	  console.log('[PHANTOM_SERVER] failed to open page.');
      callback('error', 'page opening failed');
      page.close();
      
  	} else {	
  	  setupJsonObject();
  	  includeJquery();
  	}  	
  	
  });
  
  
}



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



// @Description : Given a page object sets the cookies for this object
// @param : page:object
// @param : cookies:array[]
var setCookies = function(page, krake_query_obj) {
  console.log("[PHANTOM_SERVER] Setting Cookies");
  if(krake_query_obj.cookies) {
    for( x = 0; x < krake_query_obj.cookies.length; x++) {
      add_results = phantom.addCookie({
        name : krake_query_obj.cookies[x].name, 
        value : krake_query_obj.cookies[x].value, 
        domain : krake_query_obj.cookies[x].domain 
      });
      
      if(add_results) {
        console.log(
          '\r\n\t\tCookie was added ' + 
          '\r\n\t\t\tname : ' + krake_query_obj.cookies[x].name + ' : ' + 
          '\r\n\t\t\tvalue : ' + krake_query_obj.cookies[x].value + ' : ' + 
          '\r\n\t\t\tdomain : ' + krake_query_obj.cookies[x].domain );
        
      } else {
        console.log(
          '\r\n\t\tCookie was not added' + 
          '\r\n\t\t\tname : ' + krake_query_obj.cookies[x].name + ' : ' + 
          '\r\n\t\t\tvalue : ' + krake_query_obj.cookies[x].value + ' : ' + 
          '\r\n\t\t\tdomain : ' + krake_query_obj.cookies[x].domain );        
      }
      
    };    
  }
  return page;
  
};



// @Description : extracts the columns from the page
// @param : krake_query_obj:Object
// @param : callback:function
//    status:string - success || error
//    results:Object
var processPage = function(krake_query_obj, callback) {
  
  if(!krake_query_obj.origin_url ) {
    console.log('[PHANTOM_SERVER] origin_url not defined for \r\n\t\tURL:' + krake_query_obj.origin_url);
    callback && callback('error', 'origin_url not defined');
    return;
    
  } else if(!krake_query_obj.columns) {
    console.log('[PHANTOM_SERVER] columns not defined \r\n\t\tURL:' + krake_query_obj.origin_url);
    callback && callback('error', 'columns not defined');
    return;    
    
  } else {
    console.log('[PHANTOM_SERVER] Processing page \r\n\t\tURL:' + krake_query_obj.origin_url);
    var page = require('webpage').create();
    var domain_settings = getDomainSettings(krake_query_obj.origin_url);
    domain_settings.set_cookie && setCookies(page, krake_query_obj); 
    domain_settings.set_header && setDefaultHeader(page);
    openPage(page, krake_query_obj, function(status, results) {
      callback && callback(status, results);
      
    }) 
  }
  
};



// @Description : inclusion of jQuery
// @param : page


// The webserver
var service = server.listen(9701, function(req, res) {
  
  // Default route for testing purposes 
  if(req.url == '/') {
    res.statusCode = 200;
    res.write('I am Krake');
    res.close();
  
  // The actual route that Krake request will hit
  } else {
    
    var response = { 
      status : '', 
      message : ''
    }
    
    try {
      req.post = decodeURIComponent(req.post);
      var krake_query_obj = KSON.parse(req.post);
      processPage(krake_query_obj, function(status, results) {
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