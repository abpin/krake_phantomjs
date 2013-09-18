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
        "origin_url": "http://www.tokopedia.com/",
        "columns": [
            {
                "col_name": "category",
                "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[4]/div/div[1]/a[1]/h2[1]"
            },
            {
                "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[4]/div/div[1]/a[1]",
                "col_name": "category_link",
                "required_attribute": "href",
                "options": {
                    "columns": [
                        {
                            "col_name": "product name",
                            "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[2]/div[1]/div[2]/div[2]/ul/li/h4[1]/a[1]"
                        },
                        {
                            "col_name": "product price",
                            "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[2]/div[1]/div[2]/div[2]/ul/li/div[2]/dl[1]/dd[1]"
                        },
                        {
                            "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[2]/div[1]/div[2]/div[2]/ul/li/h4[1]/a[1]",
                            "col_name": "product name_link",
                            "required_attribute": "href",
                            "options": {
                                "columns": [
                                    {
                                        "col_name": "product rating",
                                        "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[4]/div[1]/div[3]/div[3]/ul[1]/li[5]",
                                        "regex_pattern": /[0-9]+/gi,
                                        "regex_group": 1
                                    },
                                    {
                                        "col_name": "seller page",
                                        "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[4]/div[1]/div[3]/div[3]/ul[2]/li[2]/div[2]/div[1]/a[1]"
                                    },
                                    {
                                        "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[4]/div[1]/div[3]/div[3]/ul[2]/li[2]/div[2]/div[1]/a[1]",
                                        "col_name": "seller page_link",
                                        "required_attribute": "href",
                                        "options": {
                                            "columns": [
                                                {
                                                    "col_name": "traffic",
                                                    "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[1]/div[3]/div[2]/div[1]/div[2]/div[1]",
                                                    "regex_pattern": /[0-9]+/gi
                                                },
                                                {
                                                    "col_name": "speed rating",
                                                    "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/dl[1]/dd[1]/img[1]",
                                                    "required_attribute": "src",
                                                    "regex_pattern": /[0-9]+/gi,
                                                    "regex_group": 1
                                                },
                                                {
                                                    "col_name": "accuracy rating",
                                                    "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/dl[1]/dd[2]/img[1]",
                                                    "required_attribute": "src",
                                                    "regex_pattern": /[0-9]+/gi,
                                                    "regex_group": 1
                                                },
                                                {
                                                    "col_name": "services rating",
                                                    "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[1]/div[3]/div[1]/div[1]/dl[1]/dd[3]/img[1]",
                                                    "required_attribute": "src",
                                                    "regex_pattern": /[0-9]+/gi,
                                                    "regex_group": 1
                                                },
                                                {
                                                    "col_name": "ratings page",
                                                    "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[2]/ul[1]/li[4]/a[1]"
                                                },
                                                {
                                                    "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[2]/ul[1]/li[4]/a[1]",
                                                    "col_name": "ratings page_link",
                                                    "required_attribute": "href",
                                                    "options": {
                                                        "columns": [
                                                            {
                                                                "col_name": "number of ratings",
                                                                "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[3]/div[1]/div[1]/div[1]/strong[3]"
                                                            }
                                                        ],
                                                    }
                                                }
                                            ],
                                        }
                                    }
                                ],
                            }
                        }
                    ],
                    "next_page": {
                        "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[2]/div[1]/div[2]/div[3]/ul[1]/li[8]/a[1]"
                    }
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
        expect(typeof response_obj.message.result_rows[0]['category']).toBe "string"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();