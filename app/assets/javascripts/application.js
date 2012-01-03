//= require plugins
//= require jquery-1.5.1.min
//= require jquery_ujs
//= require_self

// kein modernizr
// kein active_admin
// wird im rake rake assets:precompile herangezogen
//http://guides.rubyonrails.org/asset_pipeline.html#precompiling-assets

jQuery(function($) {
  check_user_tipp();
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







