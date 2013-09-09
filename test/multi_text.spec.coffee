http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;

counter = 0

test_call = (callback)=>
  describe "multi call, iteration " + counter , ()->
    it "should respond with success and an object ", (done)->
      post_domain = 'localhost'
      post_port = 9701
      post_path = '/';

      post_data = KSON.stringify(
        "exclude_jquery" : true,
        "origin_url": "http://maps.googleapis.com/maps/api/geocode/xml?sensor=false&address=29%20Club%20Street+Singapore",
        "columns": [
            {
                "col_name": "Latitude",
                "xpath": "//GeocodeResponse/result/geometry/location/lat",
                required_attribute : 'textContent'
            },
            {
                "col_name": "Longitude",
                "xpath": "//GeocodeResponse/result/geometry/location/lng",
                required_attribute : 'textContent'              
            },
            {
                "col_name": "Postal Code",
                "xpath": "//GeocodeResponse/result/address_component[5]/long_name",
                required_attribute : 'textContent'              
            }
        ]
      )

      post_options = {
        host: post_domain,
        port: post_port,
        path: post_path,
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
          'Content-Length': post_data.length
        }
      };

      post_req = http.request post_options, (res)=>
        res.setEncoding('utf8');
        res.on 'data', (text)=>
          expect(text).toEqual "I am Krake"
          done() 
          callback && callback()


      # write parameters to post body
      post_req.write(post_data);
      post_req.end();


audit = ()=>
  if counter < 10 
    waitsFor 'Gives the server a rest', ()=>
      test_call audit
      counter++
    , 1000

test_call audit