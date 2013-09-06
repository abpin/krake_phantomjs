http = require 'http'

describe "testing to make sure phantomjs server parses JSON successfully", ()->
  it "should respond with Krake Column length", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = JSON.stringify(
      auth_token : 'RELEASETHEKRAKEN'
      description : 'Scraping of Amazon.com'
      origin_url : 'http://www.amazon.com/s/ref=nb_sb_noss?url=search-alias%3Daps&field-keywords=iphone'
      rdbParams :
        database: 'test'
        tableName: 'combine_shopping'
        username: 'explorya'
        password: 'Explore123!'
        host:
          host: '127.0.0.1'
          port: 3306    
      columns: [{
          col_name: 'product_name'
          dom_query: '.lrg.bold'
        },{
          col_name: 'product_image'
          dom_query: '.image img'
          required_attribute : 'src'        
        },{        
          col_name : 'price'
          dom_query : 'span.bld.lrg.red' 
        }, {
          col_name: 'detailed_page'
          dom_query: '.newaps a'
          required_attribute : 'href'
          options :
            columns : [{
              col_name : 'product_description'
              dom_query : '#productDescription'
            }]
      }]
      data :
        source : 'amazon'
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
      res.on 'data', (chunk)=>
        expect(chunk).toEqual("4")
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();