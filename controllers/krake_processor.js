// A class that handles manages the various steps in a extraction of data from a page
var KrakeProcessor = function() {
  var self = this;
  self.theStack = [];
}
  
// @Descritpion : adds a middleware to theStack
// @param : middleWare:function
//    page:PhantomJsPage
//    krakeQueryObject:krakeQueryObject
//    next:function()
KrakeProcessor.prototype.use = function(middleWare) {
  var self = this;
  self.theStack.push(middleWare);
}
  
// @Descritpion : starts processing the entire stack in the queueStack given a command
// @param: page:PhantomJsPage
// @param: krakeQueryObject:krakeQueryObject
// @param: callbac:function
//    status:string - success || error
//    results:Object
KrakeProcessor.prototype.process = function(page, krakeQueryObject, callback) {
  var self = this;
  self.finalCallback = callback;
  self.page = page;
  self.krakeQueryObject = krakeQueryObject;
  self.krakeQueryObject.results = {};
  self.counter = 0;
  self.next();
}

// @Description : calls the next middle ware in theStack
KrakeProcessor.prototype.next = function() {
  var self = this;

  if(self.theStack.length > self.counter && typeof self.theStack[self.counter] == 'function' && !self.krakeQueryObject.jobStatus) {
    self.theStack[self.counter](self.page, self.krakeQueryObject, function() {
      self.counter += 1;
      self.next();
      
    });
    
  } else {
    if(!self.krakeQueryObject.jobStatus) {
      self.krakeQueryObject.jobStatus = "success";
    }
    self.finalCallback(self.krakeQueryObject.jobStatus, self.krakeQueryObject.jobResults)
    
  }

}

var exports = module.exports = KrakeProcessor;