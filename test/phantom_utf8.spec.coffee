payload_obj = false

describe "test JSON parse UTF8 in phantomjs", ()->
  it "should respond with success", (done)->
    try
      payload = '{"dom_query":"li:contains(\'商店地址\')"}'
      payload_obj = JSON.parse payload

    catch e
      
    expect(typeof payload_obj).toBe "object"          
    expect(payload_obj["dom_query"]).toEqual "li:contains('商店地址')"
    done()    