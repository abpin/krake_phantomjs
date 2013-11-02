var openPage = function(page, krake_query_obj, next) {
  console.log("[PHANTOM_SERVER] Opening page");
  
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
  	  krake_query_obj.jobStatus = 'error'
      krake_query_obj.jobResults = 'page opening failed'  	  
      page.close();
      
  	} else {	
  	  //setupJsonObject();
  	  //includeJquery();
  	} 
    next();  	
  	
  });
  
}


var exports = module.exports = openPage;