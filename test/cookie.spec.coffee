http = require 'http'
request = require 'request'
KSON = require 'kson'
express = require 'express'
jasmine.getEnv().defaultTimeoutInterval = 20000;



# Running test server
app = module.exports = express.createServer()

app.configure ()->
  app.use(express.cookieParser())
  app.use(express.bodyParser())
  app.use(app.router)
  return app.use(express["static"](__dirname + "/public"))

app.get '/', (req, res)->
  if req.cookies['x-li-idc'] == 'C1'
    res.send 'cookie header received'
  else
    res.send 'cookie header not received'

app.listen 9909



describe "test server cookie testing", ()->
  it "should respond with success as well as cookie received", (done)->
    j = request.jar()
    cookie = request.cookie('x-li-idc=C1')
    j.add(cookie)
    options = {
      url: 'http://localhost:9909/'
      , jar: j
    }
    request.get options, (error, reponse, body)=>
      expect(body).toEqual "cookie header received"
      done()
  


describe "phantom server testing", ()->
  it "should respond with success as well as cookie received", (done)->
  
    # Sending test to hit test server with
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract'

    post_data = KSON.stringify(
      "origin_url": "http://localhost:9909/",
      "columns": [
        {
            "col_name": "body",
            "dom_query" : "body"
        },
        {
            "col_name": "name",
            "xpath": "/html[1]/body[1]/div/div[1]/div[2]/div[1]/div[5]/div[3]/ol[1]/li[1]/div[1]/h3[1]/a[1]"
        }
      ],
      "cookies": [
          {
              "domain": "localhost",
              "hostOnly": true,
              "httpOnly": false,
              "name": "X-LI-IDC",
              "path": "/cookie",
              "secure": false,
              "session": true,
              "storeId": "0",
              "value": "C1"
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
        expect(response_obj.message.result_rows[0].body).toEqual "cookie header received"
        done() 



    # write parameters to post body
    post_req.write(post_data);
    post_req.end();