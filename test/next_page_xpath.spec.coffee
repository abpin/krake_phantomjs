http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;



describe "Next page using jQuery", ()->
  it "should respond with success and a string for the next page attribute ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract'
    post_data = {
        "origin_url": "http://tw.mall.yahoo.com/merchant_homepage?catid=0&searchby=sname&sort_by=product_count&order_by=0",
        "columns": [
            {
                "col_name": "shop rating",
                "xpath": "/html[1]/body[1]/div/div[1]/div[2]/div[1]/div[1]/div[1]/div[3]/div[2]/table[1]/tbody[1]/tr/td[1]/p[1]/span[1]/a[1]"
            }
        ],
        "next_page": {
            "xpath": '//*[@id="ypsaupg"]/div[2]/a[2]'
        }
    }

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
        expect(typeof response_obj.message).toEqual "object"
        expect(typeof response_obj.message.next_page).toEqual "string"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();