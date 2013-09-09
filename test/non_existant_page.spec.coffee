http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 10000;

describe "testing against non-existant url", ()->
  it "should respond with error and error message ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
      origin_url : 'http://somewhere_over_the_rainbow'
      columns: [{
          col_name: 'product_name'
          dom_query: '.lrg.bold'
        },{
          col_name: 'product_image'
          dom_query: '.image img'
          required_attribute : 'src'        
        },{        
          col_name : 'price'
          dom_query : 'span.bld.lrg.red' 
        }, {
          col_name: 'detailed_page'
          dom_query: '.newaps a'
          required_attribute : 'href'
          options :
            columns : [{
              col_name : 'product_description'
              dom_query : '#productDescription'
            }]
      }]
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
        expect(response_obj.message).toBe "page failed to finish loading"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();