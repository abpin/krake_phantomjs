http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;



describe "Test to ensure extreme long JSON query gets handled properly", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract'
    post_data = 
      "origin_url": "http://tw.mall.yahoo.com/search?m=list&sid=taaze&ccatid=2376&s=-sc_salerank&view=both&path=2376",
      "columns": [
          {
              "col_name": "product name",
              "dom_query": ".yui-g:contains('全部商品') .title a, .bd .desc a"
          },
          {
              "col_name": "product price",
              "dom_query": "span:contains(\"元\"), .price strong",
              "regex_pattern": /[0-9]+/gi
          },
          {
              "col_name": "time sold",
              "dom_query": "li:contains(\"購買人次\")",
              "regex_pattern": /[0-9]+/gi
          }
      ]

    post_data = encodeURIComponent(KSON.stringify(post_data));
    # encoding to UTF8
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
        expect(response_obj.status).toEqual "success"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();