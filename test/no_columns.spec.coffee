http = require 'http'
KSON = require 'kson'

describe "testing Krake definition with no origin url", ()->
  it "should respond with an error ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
      origin_url : 'http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=iphone'      
      data :
        source : 'amazon'
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
      res.on 'data', (raw_data)=>
        response_obj = KSON.parse raw_data
        expect(response_obj.status).toEqual "error"
        expect(response_obj.message).toEqual "columns not defined"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();