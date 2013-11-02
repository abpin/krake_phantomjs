KrakeProcessor = require '../../helpers/krake_processor'

describe "ensures krake processor does the jobs in proper order", ()->
  it "should return a result array in the right order", (done)->
    kp = new KrakeProcessor()
  
    case1 = (page, krakeQueryObject, next)->
      krakeQueryObject.jobResults = krakeQueryObject.jobResults || []
      krakeQueryObject.jobResults.push(111)
      next()
  
    case2 = (page, krakeQueryObject, next)->
      krakeQueryObject.jobResults = krakeQueryObject.jobResults || []    
      krakeQueryObject.jobResults.push(222)
      next()

    kp.use case1
    kp.use case2
  
    kp.process {}, {}, (status, results)->
      expect(status).toEqual "success"
      expect(results[0]).toEqual 111
      expect(results[1]).toEqual 222
      done();
    
    
    