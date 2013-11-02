// @extracts the DOM elements from the page  
var extractDomElements = function(page, krakeQueryObject, next) {
  
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
  results = page.evaluate(function(krakeQueryObject) {

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
    for(var x = 0; x < krakeQueryObject.columns.length ; x++) {
      
      var curr_column = krakeQueryObject.columns[x];
      
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
    if(krakeQueryObject.next_page && krakeQueryObject.next_page.xpath) { 
      results.logs.push("[PHANTOM_SERVER] extracting next page using Xpath" + 
          "\r\n\t\txpath : " + krakeQueryObject.next_page.xpath);
      var xPathResults = document.evaluate(krakeQueryObject.next_page.xpath, document);  
      var xpath_np;
      while(xpath_np = xPathResults.iterateNext()) {
         results.next_page = xpath_np.getAttribute('href');
      }        
    
    // when jQuery selector is to be used             
    } else if( (typeof jQuery == "function") && krakeQueryObject.next_page && krakeQueryObject.next_page.dom_query) {
      results.logs.push("[PHANTOM_SERVER] extracting next page using jQuery" + 
          "\r\n\t\tdom_query : " + krakeQueryObject.next_page.dom_query);
      var jquery_np = jQuery(krakeQueryObject.next_page.dom_query);
      jquery_np.length && ( results.next_page = extractAttributeFromDom(jquery_np[0], 'href') );
      
    // when jQuery has been explicitly excluded
    } else if(  (typeof jQuery != "function") && krakeQueryObject.next_page && krakeQueryObject.next_page.dom_query) {
      results.logs.push("[PHANTOM_SERVER] extracting next page using jQuery" + 
          "\r\n\t\tdom_query : " + krakeQueryObject.next_page.dom_query);
      var jquery_np = document.querySelectorAll(krakeQueryObject.next_page.dom_query);
      jquery_np.length && ( results.next_page = extractAttributeFromDom(jquery_np[0], 'href' ) );
    
    }      

    return results;
      
  }, krakeQueryObject); // eo evaluation
  console.log('[PHANTOM_SERVER] Extraction finished.');
  console.log('[PHANTOM_SERVER] Query');    
  console.log(JSON.stringify(krakeQueryObject) + '\r\n\r\n');
  console.log('[PHANTOM_SERVER] result');        
  console.log(JSON.stringify(results) + '\r\n\r\n');
  krakeQueryObject.jobResults = results
  
  //callback('success', results);
  next();
  page.close();
}

var exports = module.exports = extractDomElements;