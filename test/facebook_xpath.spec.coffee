http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;

describe "test extraction of facebook shop", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify({
      "origin_url" : "https://www.facebook.com/mylittleshoppers1/info",
      "wait" : 5000,
      "columns": [
          {
              "col_name": "joined Facebook",
              "xpath": "//th[@class='label'][contains(text(),'Joined')]/following-sibling::td[@class='data']"
          },
          {
              "col_name": "Founded",
              "xpath": "//th[@class='label'][contains(text(),'Founded')]/following-sibling::td[@class='data']"
          },
          {
              "col_name": "Products",
              "xpath": "//th[@class='label'][contains(text(),'Products')]/following-sibling::td[@class='data']"
          },          
          {
              "col_name": "Location",
              "xpath": "//th[@class='label'][contains(text(),'Location')]/following-sibling::td[@class='data']"
          },
          {
              "col_name": "Hours",
              "xpath": "//th[@class='label'][contains(text(),'Hours')]/following-sibling::td[@class='data']"
          },
          {
              "col_name": "Parking",
              "xpath": "//th[@class='label'][contains(text(),'Parking')]/following-sibling::td[@class='data']"
          },
          {
              "col_name": "Phone",
              "xpath": "//th[@class='label'][contains(text(),'Phone')]/following-sibling::td[@class='data']"
          },
          {
              "col_name": "Email",
              "xpath": "//th[@class='label'][contains(text(),'Email')]/following-sibling::td[@class='data']"
          },
          {
              "col_name": "Website",
              "xpath": "//th[@class='label'][contains(text(),'Website')]/following-sibling::td[@class='data']"
          }
        ]
    })

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
        console.log raw_data
        response_obj = KSON.parse raw_data
        expect(response_obj.status).toEqual "success"
        expect(typeof response_obj.message).toBe "object"
        expect(typeof response_obj.message.result_rows).toBe "object"
        expect(response_obj.message.result_rows[0]['joined Facebook']).toEqual "11/05/2012"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();