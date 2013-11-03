var openPage = function(page, krakeQueryObject, next) {
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
  
  // the callback that is triggered after the page is open
  callback = function(status) {

    // When opening page failed
  	if(status !== 'success') {
  	  console.log('[PHANTOM_SERVER] failed to open page.');
  	  krakeQueryObject.jobStatus = 'error'
      krakeQueryObject.jobResults = 'page opening failed'  	  
      page.close();
  	} 
  	
    next();  	

  }  
  
  // POST method
  if(krakeQueryObject.method && 
    krakeQueryObject.method == 'post' && 
    typeof krakeQueryObject.post_data == 'object' ) {
      
      queryString = Object.keys(krakeQueryObject.post_data).map(function(key){ 
        return key + "=" + krakeQueryObject.post_data[key]
      }).join("&");
      
      page.open(krakeQueryObject.origin_url, 'post', queryString, callback);        
  
  // GET method
  } else {
    page.open(krakeQueryObject.origin_url, callback);
    
  }
  
}


var exports = module.exports = openPage;