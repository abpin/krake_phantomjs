express = require 'express'
http = require 'http'
KSON = require 'kson'
request = require 'request'

describe "phantom server cookie testing", ()->

  app = false
  beforeEach ()=>
  
    # Running test server
    app = express.createServer()
    app.configure ()->
      app.use(express.cookieParser())
      app.use(express.bodyParser())
      app.use(app.router)
    app.post '/', (req, res)->
      pageBody = '<html><body><div id="value1">' + req.body.param1 + '</div>' +
        '<div id="value2">' + req.body.param2 + '</div></body></html>'
      res.send pageBody
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

    post_options = 
      host: 'localhost'
      port: 9701
      path: '/extract'
      method: 'POST'
      headers:
        'Content-Type': 'application/json'
        'Content-Length': post_data.length

    post_req = http.request post_options, (res)=>
      res.setEncoding('utf8');
      res.on 'data', (raw_data)=>
        response_obj = KSON.parse raw_data
        expect(response_obj.status).toEqual "success"
        expect(typeof response_obj.message).toBe "object"
        expect(typeof response_obj.message.result_rows).toBe "object"
        expect(typeof response_obj.message.result_rows[0]).toBe "object"
        expect(response_obj.message.result_rows[0]['res1']).toEqual "hello"
        expect(response_obj.message.result_rows[0]['res2']).toEqual "world"
        done() 


    # write parameters to post body
    post_req.write(post_data)
    post_req.end()

