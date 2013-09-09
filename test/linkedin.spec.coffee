http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;

describe "test extraction from LinkedIn using Cookies", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
      "origin_url": "http://www.linkedin.com/vsearch/p?page_num=1&orig=MDYS&keywords=singapore+chef&f_G=sg%3A0",
      "columns": [
        {
            "col_name": "name",
            "dom_query" : "body"
        },
        {
            "col_name": "name",
            "xpath": "/html[1]/body[1]/div/div[1]/div[2]/div[1]/div[5]/div[3]/ol[1]/li[1]/div[1]/h3[1]/a[1]"
        }
      ],
      "cookies": [
          {
              "domain": "www.linkedin.com",
              "hostOnly": true,
              "httpOnly": false,
              "name": "X-LI-IDC",
              "path": "/inbox/activity/notifications",
              "secure": false,
              "session": true,
              "storeId": "0",
              "value": "C1"
          },
          {
              "domain": "www.linkedin.com",
              "hostOnly": true,
              "httpOnly": false,
              "name": "X-LI-IDC",
              "path": "/vsearch",
              "secure": false,
              "session": true,
              "storeId": "0",
              "value": "C1"
          },
          {
              "domain": "www.linkedin.com",
              "hostOnly": true,
              "httpOnly": false,
              "name": "X-LI-IDC",
              "path": "/lite/ua",
              "secure": false,
              "session": true,
              "storeId": "0",
              "value": "C1"
          },
          {
              "domain": "www.linkedin.com",
              "hostOnly": true,
              "httpOnly": false,
              "name": "X-LI-IDC",
              "path": "/search",
              "secure": false,
              "session": true,
              "storeId": "0",
              "value": "C1"
          },
          {
              "domain": "www.linkedin.com",
              "hostOnly": true,
              "httpOnly": false,
              "name": "X-LI-IDC",
              "path": "/chrome",
              "secure": false,
              "session": true,
              "storeId": "0",
              "value": "C1"
          },
          {
              "domain": "www.linkedin.com",
              "hostOnly": true,
              "httpOnly": false,
              "name": "X-LI-IDC",
              "path": "/lite",
              "secure": false,
              "session": true,
              "storeId": "0",
              "value": "C1"
          },
          {
              "domain": "www.linkedin.com",
              "expirationDate": 1412298956.015958,
              "hostOnly": true,
              "httpOnly": false,
              "name": "visit",
              "path": "/",
              "secure": false,
              "session": false,
              "storeId": "0",
              "value": "\"v=1&M\""
          },
          {
              "domain": ".www.linkedin.com",
              "expirationDate": 1428780409.708664,
              "hostOnly": false,
              "httpOnly": true,
              "name": "bscookie",
              "path": "/",
              "secure": true,
              "session": false,
              "storeId": "0",
              "value": "\"v=1&201304110749164d3a0573-2847-48e4-822f-027f3a778192AQFJ5hYVxt7tkhLno-j5SgYWcqRSI9yR\""
          },
          {
              "domain": ".www.linkedin.com",
              "expirationDate": 1404879356,
              "hostOnly": false,
              "httpOnly": false,
              "name": "ebNewBandWidth_.www.linkedin.com",
              "path": "/",
              "secure": false,
              "session": false,
              "storeId": "0",
              "value": "270%3A1373343356016"
          },
          {
              "domain": "www.linkedin.com",
              "expirationDate": 1380894214,
              "hostOnly": true,
              "httpOnly": false,
              "name": "_chartbeat2",
              "path": "/",
              "secure": false,
              "session": false,
              "storeId": "0",
              "value": "2xw1al9i0u18pykf.1378302214218.1378302214218.1"
          },
          {
              "domain": "www.linkedin.com",
              "expirationDate": 1380894214,
              "hostOnly": true,
              "httpOnly": false,
              "name": "_chartbeat_uuniq",
              "path": "/",
              "secure": false,
              "session": false,
              "storeId": "0",
              "value": "1"
          },
          {
              "domain": "www.linkedin.com",
              "hostOnly": true,
              "httpOnly": false,
              "name": "L1l",
              "path": "/",
              "secure": false,
              "session": true,
              "storeId": "0",
              "value": "5220f818"
          },
          {
              "domain": ".www.linkedin.com",
              "expirationDate": 1386400342.69264,
              "hostOnly": false,
              "httpOnly": false,
              "name": "li_at",
              "path": "/",
              "secure": false,
              "session": false,
              "storeId": "0",
              "value": "\"AQEBAQCcI10AAAAEAAABQBwhRtkAAAFA_NfnLhHHwDxcb9aeuK-R0AU-UlHYiwsMmsl8lJFvgsXnIbX86F2VrjQn1qw6KyA86mYEad4whPLk_-YknGEa043KXUjRm7CHPCw-dJrU0pLminJ5VKuMIg\""
          },
          {
              "domain": ".www.linkedin.com",
              "expirationDate": 1386400342.692887,
              "hostOnly": false,
              "httpOnly": false,
              "name": "JSESSIONID",
              "path": "/",
              "secure": false,
              "session": false,
              "storeId": "0",
              "value": "\"ajax:4388053472970362202\""
          },
          {
              "domain": "www.linkedin.com",
              "expirationDate": 1378626148.583835,
              "hostOnly": true,
              "httpOnly": true,
              "name": "NSC_MC_QH_MFP",
              "path": "/",
              "secure": false,
              "session": false,
              "storeId": "0",
              "value": "ffffffffaf10085445525d5f4f58455e445a4a4219d9"
          }
      ],
      "client_version": "1.2.4"
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
        response_obj.message.result_rows[0] &&
            expect(typeof response_obj.message.result_rows[0].name).toBe "string"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();