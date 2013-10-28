http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;

describe "test Yalwa", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
      {
        origin_url : "http://www.yellowpages.co.id/browse",
        columns : [{
          col_name : "cat lvl1",
          dom_query : "a:has(span):contains('More')"
        }]
      }
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
        console.log response_obj
        expect(response_obj.status).toEqual "success"
        expect(typeof response_obj.message).toBe "object"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();