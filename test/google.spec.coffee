http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;

describe "test extraction of Geolocation from Google", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify({
        "origin_url": "https://www.google.com.sg/search?q=site:facebook.com+shopping+cart+singapore&start=0",
        "exclude_jquery": true,
        "columns": [
            {
                "col_name": "facebook shopping cart page",
                "dom_query": "h3.r a"
            },
            {
                "col_name": "facebook shopping cart page",
                "dom_query": "h3.r a",
                "required_attribute": "href",
                "options": {
                    "columns": [
                        {
                            "col_name": "shop name",
                            "dom_query": "h2"
                        },
                        {
                            "col_name": "fans",
                            "xpath": "//*[@id='fbTimelineHeadline']/div[2]/h2/div/div",
                            "regex_pattern": /[0-9,]+/gi,
                            "regex_group": 0
                        },
                        {
                            "col_name": "active conversations",
                            "xpath": "//*[@id='fbTimelineHeadline']/div[2]/h2/div/div",
                            "regex_pattern": /[0-9,]+/gi,
                            "regex_group": 1
                        },
                        {
                            "col_name": "about page",
                            "xpath": "//*[@id='pagelet_timeline_summary']/div/a",
                            "required_attribute": "href",
                            "options": {
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
                            }
                        }
                    ]
                }
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
        response_obj = KSON.parse raw_data
        console.log response_obj
        expect(response_obj.status).toEqual "success"
        expect(typeof response_obj.message).toBe "object"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();