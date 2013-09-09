# Only works when header settings not added during 
http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;

describe "test extraction from Facebook using Cookies", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
      "exclude_jquery" : true
      "wait" : 10000      
      "origin_url": "http://www.facebook.com/plugins/fan.php?connections=100&id=40796308305"
      "columns": [
          {
              "col_name": "body",
              "dom_query" : "body"
          }
      ],
      "cookies": [{
            "domain": ".facebook.com",
            "expirationDate": 1437635108.758397,
            "hostOnly": false,
            "httpOnly": true,
            "name": "datr",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "GSvuUdeUJVC8lwTibx5-EH_U"
        },
        {
            "domain": ".facebook.com",
            "expirationDate": 1437635108.758828,
            "hostOnly": false,
            "httpOnly": true,
            "name": "lu",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "ghTJVcXurxcT_66pdkx-0vEg"
        },
        {
            "domain": ".facebook.com",
            "hostOnly": false,
            "httpOnly": false,
            "name": "sub",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "35651584"
        },
        {
            "domain": ".facebook.com",
            "expirationDate": 1381222252.853406,
            "hostOnly": false,
            "httpOnly": false,
            "name": "c_user",
            "path": "/",
            "secure": true,
            "session": false,
            "storeId": "0",
            "value": "590788071"
        },
        {
            "domain": ".facebook.com",
            "expirationDate": 1381222252.853551,
            "hostOnly": false,
            "httpOnly": false,
            "name": "csm",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "2"
        },
        {
            "domain": ".facebook.com",
            "expirationDate": 1381222252.853665,
            "hostOnly": false,
            "httpOnly": true,
            "name": "fr",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "0G7HEXkWiMjZjtXUp.AWXoPGDi5Einzd8iYI1tuD_0HSs.BR7isk.sw.FIk.AWVFY09E"
        },
        {
            "domain": ".facebook.com",
            "expirationDate": 1381222252.853786,
            "hostOnly": false,
            "httpOnly": true,
            "name": "s",
            "path": "/",
            "secure": true,
            "session": false,
            "storeId": "0",
            "value": "Aa7ACS1wC6f3-BNq.BR7isk"
        },
        {
            "domain": ".facebook.com",
            "expirationDate": 1381222252.85391,
            "hostOnly": false,
            "httpOnly": true,
            "name": "xs",
            "path": "/",
            "secure": true,
            "session": false,
            "storeId": "0",
            "value": "2%3A45JjLiqS4QL9Qw%3A2%3A1374563108%3A17980"
        },
        {
            "domain": ".facebook.com",
            "hostOnly": false,
            "httpOnly": false,
            "name": "p",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "160"
        },
        {
            "domain": ".facebook.com",
            "hostOnly": false,
            "httpOnly": false,
            "name": "act",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "1378630282549%2F9"
        },
        {
            "domain": ".facebook.com",
            "hostOnly": false,
            "httpOnly": false,
            "name": "presence",
            "path": "/",
            "secure": true,
            "session": true,
            "storeId": "0",
            "value": "EM378630340EuserFA2590788071A2EstateFDsb2F0Et2F_5b_5dElm2FnullEuct2F1378629649BEtrFnullEtwF745940961EatF1378630319191G378630340641CEchFDp_5f590788071F2897CC"
        },
        {
            "domain": ".facebook.com",
            "hostOnly": false,
            "httpOnly": false,
            "name": "wd",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "1361x647"
        }]
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