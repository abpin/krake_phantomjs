// Gets the value of a DOM attribute
var extractDomAttributes = function(dom_obj, required_attribute) {

  var return_val = '';

  switch(required_attribute) {
    case 'href'       :
    case 'src'        :
      return_val = dom_obj[required_attribute];
      break;

    case 'innerHTML'  : 
      return_val = dom_obj.innerHTML;
      break;

    case 'innerText'  :
    case 'textContent':
    case 'address'    :
    case 'email'      :
    case 'phone'      :
      return_val = dom_obj.textContent || dom_obj.innerText;
      break;

    default : 
      return_val = required_attribute && dom_obj.getAttribute(required_attribute)
      !return_val && (return_val = dom_obj.textContent)
  }

  return return_val && return_val.trim() || ''

}