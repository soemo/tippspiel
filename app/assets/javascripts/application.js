//= require plugins
//= require jquery-1.7.1.min
//= require jquery_ujs
//= require bootstrap

$(function() {
  check_user_tipp();

  //TEst Bootstrap
  $('#testtooltip').tooltip();
  // Test collapse
  $(".collapse").collapse('hide');
});


function check_user_tipp() {
  $(".tipp_input").keyup( function() {
      var cur_val = $(this).val(); // grab what's in the field
      // do stuff with cur_val so that it's what you want
      if (isNaN( cur_val )) {
        // It isn't a number
        cur_val = cur_val.substr(0,cur_val.length-1);
      } else {
        // It is a number
       }

      $(this).val(cur_val);
  });
}







