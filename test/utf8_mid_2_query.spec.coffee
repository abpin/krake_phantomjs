http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;



describe "Test to ensure extreme long JSON query gets handled properly", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract'
    post_data = {
        "origin_url": "http://tw.mall.yahoo.com/merchant_homepage?catid=0&searchby=sname&sort_by=product_count&order_by=0",
        "columns": [
            {
                "col_name": "shop rating",
                "xpath": "/html[1]/body[1]/div/div[1]/div[2]/div[1]/div[1]/div[1]/div[3]/div[2]/table[1]/tbody[1]/tr/td[1]/p[1]/span[1]/a[1]"
            },
            {
                "xpath": "/html[1]/body[1]/div/div[1]/div[2]/div[1]/div[1]/div[1]/div[3]/div[2]/table[1]/tbody[1]/tr/td[1]/p[1]/span[1]/a[1]",
                "col_name": "shop rating page",
                "required_attribute": "href",
                "options": {
                    "columns": [
                        {
                            "col_name": "shop name",
                            "dom_query": ".title h1"
                        },
                        {
                            "col_name": "past week viewer traffic",
                            "xpath": "/html[1]/body[1]/div/div[3]/div[2]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[1]/div[1]/div[1]/div[1]/div[2]/div[1]/div[2]",
                            "regex_pattern": /[0-9]+/gi,
                            "regex_group": 0
                        },
                        {
                            "col_name": "number of rating",
                            "xpath": "/html[1]/body[1]/div/div[3]/div[2]/div[1]/div[1]/div[1]/div[2]/div[2]/div[1]/div[1]/div[1]/div[2]/div[1]/span[1]",
                            "regex_pattern": /[0-9]+/gi,
                            "regex_group": 2
                        },
                        {
                            "col_name": "shop contact page",
                            "dom_query": "a:contains('商店介紹')",
                            "required_attribute": "href",
                            "options": {
                                "columns": [
                                    {
                                        "col_name": "phone",
                                        "dom_query": "li:contains('服務電話')",
                                        "regex_pattern": /[0-9]+/
                                    },
                                    {
                                        "col_name": "shop fax",
                                        "dom_query": "li:contains('傳真號碼')",
                                        "regex_pattern": /[0-9]+/
                                    },
                                    {
                                        "col_name": "address",
                                        "dom_query": "li:contains('商店地址')",
                                        "regex_pattern": /[^：]+/gi,
                                        "regex_group": 1
                                    },
                                    {
                                        "col_name": "person in charge",
                                        "dom_query": "li:contains('商業負責人')",
                                        "regex_pattern": /[^：]+/gi,
                                        "regex_group": 1
                                    },
                                    {
                                        "col_name": "shop name",
                                        "dom_query": "li:contains('商店名稱')",
                                        "options": {
                                            "origin_url": "@@shop rating page@@",
                                            "columns": [
                                                {
                                                    "col_name": "category",
                                                    "dom_query": "#ypsuf h4 a",
                                                    "options": {
                                                        "origin_url": "@@category page@@&view=both",
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
                                                    }
                                                },
                                                {
                                                    "col_name": "category page",
                                                    "dom_query": "#ypsuf h4 a",
                                                    "required_attribute": "href"
                                                }
                                            ]
                                        }
                                    }
                                ]
                            }
                        }
                    ]
                }
            }
        ],
        "next_page": {
            "dom_query": ".pages strong+a"
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
        console.log response_obj
        expect(response_obj.status).toEqual "success"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();