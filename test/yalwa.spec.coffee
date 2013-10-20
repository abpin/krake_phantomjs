http = require 'http'
KSON = require 'kson'
jasmine.getEnv().defaultTimeoutInterval = 20000;

describe "test Yalwa", ()->
  it "should respond with success and an object ", (done)->
    post_domain = 'localhost'
    post_port = 9701
    post_path = '/extract';

    post_data = KSON.stringify(
      {
          origin_url : "http://www.yalwa.sg/",
          columns: [
              {
                  col_name: "cat 1",
                  dom_query: "#tabs a"
              },
              {
                  col_name: "cat 1 page",
                  dom_query: "#tabs a",
                  required_attribute: "href",
                  options: {
                      columns: [
                          {
                              col_name: "cat 2",
                              dom_query: "#category_list a"
                          },
                          {
                              col_name: "cat 2 page",
                              dom_query: "#category_list a",
                              required_attribute: "href",
                              options: {
                                  next_page: {
                                      dom_query: ".paging a:contains('Next')"
                                  },
                                  columns: [
                                      {
                                          col_name: "company name",
                                          dom_query: ".resultMain .textHeader a"
                                      },
                                      {
                                          col_name: "company rating",
                                          dom_query: ".resultMain .star_blue"
                                      },
                                      {
                                          col_name: "company description",
                                          dom_query: ".resultMain .textDesc"
                                      },
                                      {
                                          col_name: "company category",
                                          dom_query: "span:contains('Category') a"
                                      },
                                      {
                                          col_name: "company page",
                                          dom_query: ".resultMain .textHeader a",
                                          required_attribute: "href",
                                          options: {
                                              columns: [
                                                  {
                                                      col_name: "email",
                                                      dom_query: ".user_content",
                                                      required_attribute: "email"
                                                  },
                                                  {
                                                      col_name: "phone",
                                                      dom_query: ".user_content",
                                                      required_attribute: "phone"
                                                  }
                                              ]
                                          }
                                      }
                                  ]
                              }
                          }
                      ]
                  }
              }
          ]
      }      
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
        console.log response_obj
        expect(response_obj.status).toEqual "success"
        expect(typeof response_obj.message).toBe "object"
        done() 


    # write parameters to post body
    post_req.write(post_data);
    post_req.end();