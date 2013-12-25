// Overriding the XMLHttpRequest prototype
XMLHttpRequest.prototype._open = XMLHttpRequest.prototype.open
XMLHttpRequest.prototype.open = function() { console.log(arguments)
  console.log(arguments[0])
  XMLHttpRequest.prototype._open.apply(this, arguments)
  window.callPhantom({ event: "xml_http_req", method: arguments[0], url: arguments[1] });
};

// Handlings the page unload event
window.addEventListener('pagehide', function() {
  window.callPhantom({ event: "page_load" });
}, false);