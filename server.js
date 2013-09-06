// This files is to be ran using PhantomJS

// Creation of web server
var server = require('webserver').create();



// @Description : extracts the columns from the page
// @param : krake_query_obj:Object
// @param : callback:function
//    status:string - success || error
//    results:Object
var processPage = function(krake_query_obj, callback) {
  callback && callback('success', 4);
  
}



// The webserver
var service = server.listen(9701, function(req, res) {
  
  // Default route for testing purposes 
  if(req.url == '/') {
    res.statusCode = 200;
    res.write('I am Krake');
    res.close();
  
  // The actual route that Krake request will hit
  } else {
    
    try {
      var krake_query_obj = JSON.parse(req.post)
      processPage(krake_query_obj, function(status, results) {

        if(status == 'success') {
          res.write(results);

        } else {
          res.write('ERROR');

        }

      });
      
    } catch (e) {
      res.write('ERROR');
      
    }
  }

});

console.log('Running phantom webserver at port : ', server.port);