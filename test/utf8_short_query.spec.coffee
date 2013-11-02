http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;



describe "Test to ensure UTF8 encoding gets handled properly", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract'
    post_data = '全部商品'
    post_data = encodeURIComponent(KSON.stringify(post_data))
    post_options =
      host: post_domain
      port: post_port
      path: post_path
      method: 'POST'
      headers:
       'Content-Length': post_data.length

    post_req = http.request post_options, (res)=>
      res.setEncoding('utf8');
      res.on 'data', (raw_data)=>
        response_obj = KSON.parse raw_data
        expect(response_obj.status).toEqual "error"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();