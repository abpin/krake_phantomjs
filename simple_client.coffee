http = require 'http'
KSON = require 'kson'

post_domain = 'localhost'
post_port = 9701
post_path = '/extract';

post_data = KSON.stringify({
  "origin_url": "http://search.yahoo.com/local/s;_ylt=A2KLOzJFxVRSzgYARzXumYlQ?p=hotel+gift+shops&amp;addr=massacussets&amp;xargs=0&amp;pstart=1&amp;b=1",
  "columns": [
    {
      "col_name": "hotel",
      "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[4]/ol[1]/li/div[1]/div[1]/h3[1]/a[1]"
    },
    {
      "col_name": "web",
      "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[4]/ol[1]/li/div[1]/div[1]/div[2]/a[1]"
    },
    {
      "col_name": "address",
      "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[4]/ol[1]/li/div[1]/div[1]/div[3]"
    },
    {
      "col_name": "phone",
      "xpath": "/html[1]/body[1]/div/div[3]/div[1]/div[2]/div[1]/div[1]/div[1]/div[4]/ol[1]/li/div[1]/div[1]/div[4]"
    }
  ]
})

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


# write parameters to post body
post_req.write(post_data);
post_req.end();