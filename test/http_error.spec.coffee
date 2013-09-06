http = require 'http'

describe "testing to make sure phantomjs server catches illed formed JSON correctly", ()->
  it "should respond with error message", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = '{what the fuck'

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
      res.on 'data', (chunk)=>
        expect(chunk).toEqual("ERROR")
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();