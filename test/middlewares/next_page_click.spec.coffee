express = require 'express'
http = require 'http'
KSON = require 'kson'
request = require 'request'
testClient = require '../fixtures/test_client'

jasmine.getEnv().defaultTimeoutInterval = 20000

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

  it "should not recognize a non-valid html item load as a page load", (done)->
    post_data = KSON.stringify(
      {
        "origin_url" : "http://www.spud.ca/catalogue/catalogue.cfm?action=D=&M=41&W=1&OP=C4&PG=0&CG=3&S=1&Search=&qry=1%20eq%200&qqq2=1%20%3D%200&st=1#",
        "render" : true,
        "wait" : 1000,
        "next_page" : {
          "dom_query" : "#pagination-spud .nextpage a",
          "click" : true
        },
        "columns": [
            {
                "col_name": "next pages",
                "dom_query": "#pagination-spud .nextpage a"
            },
            {
                "col_name": "next pages script",
                "dom_query": "#pagination-spud .nextpage a",
                "required_attribute" : "onclick"
            }            
        ],
        "cookies": [{
            "domain": "www.spud.ca",
            "expirationDate": 2333739434.911558,
            "hostOnly": true,
            "httpOnly": false,
            "name": "SPUD_CUSTCODE",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "VISITOR"
        },
        {
            "domain": "www.spud.ca",
            "hostOnly": true,
            "httpOnly": false,
            "name": "LB-Persist",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "!sFD+7nNWwpLsLCBZb3YYFdM4ywS/VYD1KJv1OU/4LiEHm7msBTP+d1V/lZUk4kjvzE3ovKZ2mc+4Xw=="
        },
        {
            "domain": "www.spud.ca",
            "hostOnly": true,
            "httpOnly": false,
            "name": "SPUD_ZIPPOST_MYLOC",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "V5L%201S6%20myLoc1"
        },
        {
            "domain": "www.spud.ca",
            "hostOnly": true,
            "httpOnly": false,
            "name": "WARMSG",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "0"
        },
        {
            "domain": "www.spud.ca",
            "hostOnly": true,
            "httpOnly": false,
            "name": "WARMSG2",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "0"
        },
        {
            "domain": "www.spud.ca",
            "expirationDate": 2334034691.172495,
            "hostOnly": true,
            "httpOnly": false,
            "name": "SPUD_ZIP",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "V5L%201S6"
        },
        {
            "domain": "www.spud.ca",
            "expirationDate": 2334034691.172589,
            "hostOnly": true,
            "httpOnly": false,
            "name": "SPUD_MYLOC",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "1"
        },
        {
            "domain": "www.spud.ca",
            "expirationDate": 2334034691.172684,
            "hostOnly": true,
            "httpOnly": false,
            "name": "SPUD_LOCALE",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "1"
        },
        {
            "domain": "www.spud.ca",
            "hostOnly": true,
            "httpOnly": false,
            "name": "CFID",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "12536193"
        },
        {
            "domain": "www.spud.ca",
            "hostOnly": true,
            "httpOnly": false,
            "name": "CFTOKEN",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "37b6def03bd0a1a8%2D9577A76B%2D9189%2DA63B%2D909C16C1BEE5E1F4"
        },
        {
            "domain": ".spud.ca",
            "expirationDate": 1451027696,
            "hostOnly": false,
            "httpOnly": false,
            "name": "__utma",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "144952182.1286649324.1387659406.1387932000.1387954693.8"
        },
        {
            "domain": ".spud.ca",
            "expirationDate": 1387957496,
            "hostOnly": false,
            "httpOnly": false,
            "name": "__utmb",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "144952182.4.10.1387954693"
        },
        {
            "domain": ".spud.ca",
            "hostOnly": false,
            "httpOnly": false,
            "name": "__utmc",
            "path": "/",
            "secure": false,
            "session": true,
            "storeId": "0",
            "value": "144952182"
        },
        {
            "domain": ".spud.ca",
            "expirationDate": 1403723696,
            "hostOnly": false,
            "httpOnly": false,
            "name": "__utmz",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "144952182.1387659406.1.1.utmcsr=(direct)|utmccn=(direct)|utmcmd=(none)"
        },
        {
            "domain": ".www.spud.ca",
            "expirationDate": 1567955697,
            "hostOnly": false,
            "httpOnly": false,
            "name": "__ar_v4",
            "path": "/",
            "secure": false,
            "session": false,
            "storeId": "0",
            "value": "PSKXKCDDJZGA5FQDC4NRYS%3A20140020%3A10%7C2LXOQ7LOYJDUXKWU5BSE6F%3A20140020%3A47%7CNKDK5A2WTNC6HDVVBAW2CQ%3A20140020%3A47%7CMAUAMZC4AZGEJD5T5SVVJ2%3A20140020%3A37"
        }]
      }
    )

    testClient post_data, (response_obj)-> 
      expect(response_obj.status).toEqual "success"
      expect(typeof response_obj.message).toEqual "object"
      expect(typeof response_obj.message.next_page).toBe "string"
      expect(response_obj.message.next_page).toEqual "http://www.spud.ca/catalogue/catalogue.cfm?action=D=&M=41&W=1&OP=C4&PG=0&CG=3&S=1&Search=&qry=1 eq 0&qqq2=1 = 0&st=2"
      done()

  it "should only return the Ajax response that is of HTMl object type as the next page url", (done)->
    post_data = KSON.stringify(
      "origin_url" : "http://localhost:9999/next_page_ajax_double"
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
      expect(response_obj.message.next_page).not.toEqual "http://localhost:9999/json-obj"
      expect(response_obj.message.next_page).toEqual "http://localhost:9999/success_delayed"
      done()      


