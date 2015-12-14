// $(document).ready(function() {
// // Remove the whitespace from between child elements
//   $('.removeTextNodes').contents().filter(function() {
//     return this.nodeType === 3;
//   }).remove();
// });

var ready;
ready = function() {

  // ...your javascript goes here...
  // Remove the whitespace from between child elements
    $('.removeTextNodes').contents().filter(function() {
      return this.nodeType === 3;
    }).remove();

};

$(document).ready(ready);
$(document).on('page:load', ready);
