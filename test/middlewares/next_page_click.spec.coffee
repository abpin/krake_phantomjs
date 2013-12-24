express = require 'express'
http = require 'http'
KSON = require 'kson'
request = require 'request'
testClient = require '../fixtures/test_client'

describe "Next page click", ()->

  app = false
  beforeEach ()=>
  
    # Running test server
    app = require '../fixtures/test_server'
    app.listen 9999
  
  afterEach ()=>
    app.close()
      
  it "should return next page HTTP POST url through click", (done)->
    post_data = KSON.stringify(
      "origin_url" : "http://localhost:9999/next_page_post"
      "columns": [{
        "col_name": "col 1",
        "dom_query": "#col1"
      }],
      "next_page" :
        "dom_query" : '#next_page'
        "click" : true
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toEqual "object"
      expect(typeof response_obj.message.next_page).toEqual "string"
      expect(response_obj.message.next_page).toEqual "http://localhost:9999/success?"
      done()

  it "should return next page HTTP GET url through click", (done)->
    post_data = KSON.stringify(
      "origin_url" : "http://localhost:9999/next_page_js"
      "columns": [{
        "col_name": "col 1",
        "dom_query": "#col1"
      }],
      "next_page" :
        "dom_query" : '#next_page'
        "click" : true
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toEqual "object"
      expect(typeof response_obj.message.next_page).toEqual "string"
      expect(response_obj.message.next_page).toEqual "http://localhost:9999/success"
      done()

  it "should yield undefined and not time out if click did not get any URL", (done)->
    post_data = KSON.stringify(
      "origin_url" : "http://localhost:9999/next_page_empty"
      "columns": [{
        "col_name": "col 1",
        "dom_query": "#col1"
      }],
      "next_page" :
        "dom_query" : '#next_page'
        "click" : true
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toEqual "object"
      expect(typeof response_obj.message.next_page).toBe "undefined"
      done()

  it "should return next page Ajax url through click", (done)->
    post_data = KSON.stringify(
      "origin_url" : "http://localhost:9999/next_page_ajax"
      "columns": [{
        "col_name": "col 1",
        "dom_query": "#col1"
      }],
      "next_page" :
        "dom_query" : '#next_page'
        "click" : true
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toEqual "object"
      expect(typeof response_obj.message.next_page).toEqual "string"
      expect(response_obj.message.next_page).toEqual "http://localhost:9999/success"
      done()

  it "should not time out when getting next_page if the actual next_page is slow to load", (done)->
    post_data = KSON.stringify(
      "origin_url" : "http://localhost:9999/next_page_slow"
      "columns": [{
        "col_name": "col 1",
        "dom_query": "#col1"
      }],
      "next_page" :
        "dom_query" : '#next_page'
        "click" : true
    )
    
    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toEqual "object"
      expect(typeof response_obj.message.next_page).toBe "undefined"
      done()
