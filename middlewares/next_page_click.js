// @extracts the next page url from the page  
var nextPageClick = function(page, krakeQueryObject, next) {

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
  
  // When is getting the next page url via clicking
  if(krakeQueryObject.next_page && krakeQueryObject.next_page.click) {

    console.log('[PHANTOM_SERVER] extracting Next Page via clicking on the anchor element');
    krakeQueryObject.jobResults = krakeQueryObject.jobResults || {};

    var timed_out = false
    var time_cop = setTimeout(function() {
      console.log('[PHANTOM_SERVER] Click Next Page Timed out');
      timed_out = true;
      next();
    }, 500);

    page.onResourceRequested = function(requestData, networkRequest) {
      if(!timed_out) {
        // console.log('Resource Request (' + requestData.id + '): ' + JSON.stringify(requestData));
        console.log('[PHANTOM_SERVER] Click Next Page URL : ' + requestData.url);
        networkRequest.abort();
        krakeQueryObject.jobResults.next_page = requestData.url
        page.onResourceRequested = false;
        clearTimeout(time_cop)
        delete time_cop
        next();        
      }

    };

    click_logs = page.evaluate(function(krakeQueryObject) {
      var logs = []
      var evt = document.createEvent("MouseEvent");
      evt.initMouseEvent("click", true, true, window, 0, 0, 0, 0, 0, false, false, false, false, 0, null);
      
      if(krakeQueryObject.next_page && krakeQueryObject.next_page.xpath) { 
        logs.push("clicking using xpath");
        var xPathResults = document.evaluate(krakeQueryObject.next_page.xpath, document);
        element = xPathResults.iterateNext();

      } else if( (typeof jQuery == "function") && krakeQueryObject.next_page && krakeQueryObject.next_page.dom_query) {
        logs.push("clicking using jquery");
        var jquery_np = jQuery(krakeQueryObject.next_page.dom_query);
        element = jquery_np[0];

      } else if(  (typeof jQuery != "function") && krakeQueryObject.next_page && krakeQueryObject.next_page.dom_query) {
        logs.push("clicking using querySelectorAll");
        var jquery_np = document.querySelectorAll(krakeQueryObject.next_page.dom_query);
        element = jquery_np[0];
      }

      if(element){
        logs.push("click element found");
        element.dispatchEvent(evt); 
      } else {
        logs.push("click element not found");
      }
      return logs;
    }, krakeQueryObject);

    console.log("[PHANTOM_SERVER] next page click logs: " + click_logs.join(","))

    
  // When next_page operator was not specified
  } else {
    next();

  }

}

// Removes all the hooks placed in this page to catch next page URLs
var cleanUpPage = function(page) {
  page.onResourceRequested =  false 
}

var exports = module.exports = nextPageClick;