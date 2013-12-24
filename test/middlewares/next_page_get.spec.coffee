express = require 'express'
http = require 'http'
KSON = require 'kson'
request = require 'request'
testClient = require '../fixtures/test_client'

describe "Next page", ()->

  app = false
  beforeEach ()=>
  
    # Running test server
    app = require '../fixtures/test_server'
    app.listen 9999
  
  afterEach ()=>
    app.close()
      
  it "should respond with success as well as cookie received", (done)->

    post_data = KSON.stringify(
      "origin_url": "http://localhost:9999"
      "columns": [{
        "col_name": "res1"
        "dom_query": "#value1"
      },{
        "col_name": "res2"
        "dom_query": "#value2"
      }],
      "method" : "post"
      "post_data" :
        "param1" : "hello"
        "param2" : "world"
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toBe "object"
      expect(typeof response_obj.message.result_rows).toBe "object"
      expect(typeof response_obj.message.result_rows[0]).toBe "object"
      expect(response_obj.message.result_rows[0]['res1']).toEqual "hello"
      expect(response_obj.message.result_rows[0]['res2']).toEqual "world"
      done() 

  it "should respond with success and a string for the next page attribute when using dom_query in next_page", (done)->
    post_data = KSON.stringify(
        "origin_url": "http://localhost:9999/next_page_get"
        "columns": [{
          "col_name": "col 1",
          "dom_query": "#col1"
        }]
        "next_page":
          "dom_query": '#next_page'
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toEqual "object"
      expect(typeof response_obj.message.next_page).toEqual "string"
      expect(response_obj.message.next_page).toEqual "http://localhost:9999/success"
      done() 
    
  it "should respond with success and a string for the next page attribute when using xpath in next_page", (done)->
    post_data = KSON.stringify(
        "origin_url": "http://localhost:9999/next_page_get"
        "columns": [{
          "col_name": "col 1",
          "dom_query": "#col1"
        }]
        "next_page":
          "xpath": '//*[@id="next_page"]'
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toEqual "object"
      expect(typeof response_obj.message.next_page).toEqual "string"
      expect(response_obj.message.next_page).toEqual "http://localhost:9999/success"
      done() 
