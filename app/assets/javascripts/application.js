//= require jquery
//= require jquery_ujs
//= require jquery.lwtCountdown-1.0
//= require bootstrap

$(function() {
  check_user_tipp();

  // Navbar
  $(".collapse").collapse('hide');
  // Ranking Statistik Punkte
  $('.statistic_popover').popover({
    placement: "left"
  });

  //Countdown - DATUM des ersten Spiels
  $('#countdown_dashboard').countDown({
    targetDate:{
      'day':8,
      'month':6,
      'year':2012,
      'hour':18,
      'min':0,
      'sec':0
    }
  });
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







