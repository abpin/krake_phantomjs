// @extracts the DOM elements from the page  
var domElements = function(page, krakeQueryObject, next) {
  
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

    var results = krakeQueryObject.jobResults || {};
    results.logs = results.logs || [];
    results.result_rows = results.result_rows || [];

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
            curr_result_row[curr_column['col_name']] = extractDomAttributes(jquery_results[y], curr_column['required_attribute']);
            results.result_rows[y] = curr_result_row;
          }
          
        } else {
          var jquery_results = [];
          jQuery(curr_column.dom_query).map(function(index, item) {
            jquery_results.push(extractDomAttributes(item, curr_column['required_attribute']));
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
            curr_result_row[curr_column['col_name']] = extractDomAttributes(query_results[y], curr_column['required_attribute']);
            results.result_rows[y] = curr_result_row;
          }
          
        } else {
          var query_results = document.querySelectorAll(curr_column.dom_query);
          var final_results = [];
          for (var y = 0; y < query_results.length ; y++ ) {
            final_results.push(extractDomAttributes(query_results[y], curr_column['required_attribute']));
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
            curr_result_row[ curr_column['col_name'] ] = extractDomAttributes(curr_item, curr_column['required_attribute']);
            results.result_rows[y] = curr_result_row;
            y++;
          }
          
        } else {
          var final_results = [];
          while(curr_item = xPathResults.iterateNext()) {
            final_results.push(extractDomAttributes(curr_item, curr_column['required_attribute']));
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
    
    return results;
      
  }, krakeQueryObject); // eo evaluation
  console.log('[PHANTOM_SERVER] Extraction finished.');
  console.log('[PHANTOM_SERVER] Processing Query');    
  // console.log(JSON.stringify(krakeQueryObject) + '\r\n\r\n');
  console.log('[PHANTOM_SERVER] Retrieved Results');        
  // console.log(JSON.stringify(results) + '\r\n\r\n');
  krakeQueryObject.jobResults = results
  
  next();
}

var exports = module.exports = domElements;