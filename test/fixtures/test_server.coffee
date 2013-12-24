express = require 'express'

app = express.createServer()
app.configure ()->
  app.set 'views', __dirname + '/views'
  app.set 'view engine', 'ejs'
  app.use express.cookieParser()
  app.use express.bodyParser()
  app.use(express["static"](__dirname + "/public"))
  app.use(app.router)

app.post '/', (req, res)->
  res.render 'post_method', { param1: req.body.param1, param2: req.body.param2}

app.post '/success', (req, res)->
  res.render 'success'

app.get '/success', (req, res)->
  res.render 'success'

app.get '/next_page_js', (req, res)->
  res.render 'next_page_js'

app.get '/next_page_get', (req, res)->
  res.render 'next_page_get'

app.get '/next_page_post', (req, res)->
  res.render 'next_page_post'

app.get '/next_page_empty', (req, res)->
  res.render 'next_page_empty'

app.get '/next_page_ajax', (req, res)->
  res.render 'next_page_ajax'

app.get '/timeout', (req, res)->

exports = module.exports = app

if !module.parent
  console.log 'Testing server listening at port 9999'
  app.listen 9999