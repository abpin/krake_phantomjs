setHeader = require '../../middlewares/set_headers'

describe "ensures headers are set properly", ()->
  it "should not set header for facebook", (done)->  
    page =
      settings : []
    krakeQueryObject =
      origin_url : "https://www.google.com/#q=what+to+do"
      
    setHeader page, krakeQueryObject, ()->
      expect(page.settings['userAgent']).toEqual 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_5) AppleWebKit/537.1 (KHTML, like Gecko) Chrome/21.0.1180.89 Safari/537.1'
      done()