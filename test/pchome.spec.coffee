# Only works when header settings not added during 
http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;

describe "Tokopedia test", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
      "origin_url" : "http://shopping.pchome.com.tw/?mod=store&func=style_show&SR_NO=CFAJ0I",
      "columns": [
          {
              "dom_query": "a[href*='?mod=item&func=exhibit']",
              "col_name": "product_page_link",
              "required_attribute": "href",
              "options": {
                  "columns": [
                      {
                          "col_name": "product name",
                          "xpath": "//*[@id='order']/table[2]/tbody/tr[2]/td[2]/table[1]/tbody/tr[1]/td[1]/font",
                          "required_attribute": "innerText"
                      },
                      {
                          "col_name": " price",
                          "xpath": "/html[1]/body[1]/div/table[3]/tbody[1]/tr[2]/td[1]/table[1]/tbody[1]/tr[1]/td[1]/table[1]/tbody[1]/tr[1]/td[1]/form[1]/table[2]/tbody[1]/tr[2]/td[2]/div[1]/table[1]/tbody[1]/tr[3]/td[3]/table[1]/tbody[1]/tr[1]/td[1]/font[1]/font[1]/font[1]/span[1]"
                      }
                  ]
              }
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
      res.on 'data', (raw_data)=>
        response_obj = KSON.parse raw_data
        expect(response_obj.status).toEqual "success"
        expect(typeof response_obj.message).toBe "object"
        expect(typeof response_obj.message.result_rows[0]).toBe "object"
        expect(typeof response_obj.message.result_rows[0]['product_page_link']).toBe "string"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();