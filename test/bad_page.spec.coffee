http = require 'http'
KSON = require 'kson'

describe "testing bad page on lelong.com.my", ()->
  it "should not crash", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
       "exclude_jquery" : true,
       "origin_url": "http://www.lelong.com.my/Auc/Feedback/UserRating.asp?UserID=CoconutIsland@1",
       "columns": [
           {
               "col_name": "email address",
               "xpath": '//*[@id="SellerInfoContainer"]/table/tbody/tr[2]/td[3]/a',
               required_attribute : 'href'
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
        expect(typeof response_obj.message.result_rows).toBe "object"
        expect(typeof response_obj.message.result_rows[0]).toBe "object"
        expect(response_obj.message.result_rows[0]['email address']).toEqual "mailto:coconutisland@hotmail.my"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();



