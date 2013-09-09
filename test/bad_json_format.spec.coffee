http = require 'http'
KSON = require 'kson'

describe "testing badly formed JSON", ()->
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
      res.on 'data', (raw_data)=>
        response_obj = KSON.parse raw_data
        expect(response_obj.status).toEqual "error"
        expect(response_obj.message).toEqual "cannot render Krake query object"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();