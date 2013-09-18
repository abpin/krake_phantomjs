# Only works when header settings not added during 
http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;

describe "Trip advisor test", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
        "origin_url": "http://www.tripadvisor.com.sg/Attractions-g294265-Activities-Singapore.html",
        "columns": [
            {
                "col_name": "place name",
                "xpath": "/html[1]/body[1]/div/div[2]/div[2]/div[5]/div[1]/div[1]/div[2]/div[1]/div/div[2]/a[1]"
            },
            {
                "xpath": "/html[1]/body[1]/div/div[2]/div[2]/div[5]/div[1]/div[1]/div[2]/div[1]/div/div[2]/a[1]",
                "col_name": "place name_link",
                "required_attribute": "href",
                "options": {
                    "columns": [
                        {
                            "col_name": "address",
                            "xpath": "/html[1]/body[1]/div/div[2]/div[2]/div[1]/div[4]/div[1]/div[2]/div[2]/address[1]"
                        },
                        {
                            "col_name": "phone",
                            "xpath": "/html[1]/body[1]/div/div[2]/div[2]/div[1]/div[4]/div[1]/div[2]/div[2]/div[1]/div[1]/div[2]"
                        },
                        {
                            "col_name": "number of reviews",
                            "xpath": "/html[1]/body[1]/div/div[2]/div[2]/div[1]/div[4]/div[1]/div[4]/div[1]/h3[1]"
                        },
                        {
                            "col_name": "attraction ranking",
                            "xpath": "/html[1]/body[1]/div/div[2]/div[2]/div[1]/div[4]/div[1]/div[3]/div[1]/div[2]/div[1]/span[1]/div[1]/b[1]/span[1]"
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
        expect(response_obj.message.result_rows[0]['place name']).toBe "Food Playground"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();