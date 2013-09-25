http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 50000;

describe "test extraction of compound Product Listing Info from MDScollections xpath", ()->
  it "should respond with success and string of CSV string", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
      origin_url : "http://www.mdscollections.com/cat-new-in-clothing.cfm"
      columns : [{
          col_name : 'product_price'
          xpath : '//span[@class="listing_price"]',
          is_compound : true
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
        expect(typeof response_obj.message.result_rows).toBe "object"
        expect(typeof response_obj.message.result_rows[0]).toBe "object"
        expect(typeof response_obj.message.result_rows[0].product_price).toBe "string"
        console.log response_obj.message.result_rows[0].product_price
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();
    
    
describe "test extraction of compound Product Listing Info from MDScollections jQuery", ()->
  it "should respond with success and string of CSV string ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
      origin_url : "http://www.mdscollections.com/cat-new-in-clothing.cfm"
      columns : [{
          col_name : 'product_price'
          dom_query : '.listing_price',
          is_compound : true
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
        expect(typeof response_obj.message.result_rows).toBe "object"
        expect(typeof response_obj.message.result_rows[0]).toBe "object"
        expect(typeof response_obj.message.result_rows[0].product_price).toBe "string"
        console.log response_obj.message.result_rows[0].product_price
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();
    
    
describe "test extraction of compound Product Listing Info from MDScollections CSS Selector", ()->
  it "should respond with success and string of CSV string ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
      origin_url : "http://www.mdscollections.com/cat-new-in-clothing.cfm"
      columns : [{
          col_name : 'product_price'
          dom_query : '.listing_price',
          exclude_jquery : true,
          is_compound : true
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
        expect(typeof response_obj.message.result_rows).toBe "object"
        expect(typeof response_obj.message.result_rows[0]).toBe "object"
        expect(typeof response_obj.message.result_rows[0].product_price).toBe "string"
        console.log response_obj.message.result_rows[0].product_price
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();