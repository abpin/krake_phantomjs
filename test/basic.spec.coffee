# @Dependencies
request = require 'request'

describe "testing to make sure phantomjs server is running", ()->
  it "should respond with I am Krake", (done)->
    request "http://localhost:9701/", (error, response, body)->
      expect(body).toEqual "I am Krake"
      done()