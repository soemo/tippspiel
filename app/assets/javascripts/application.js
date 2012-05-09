//= require jquery
//= require jquery_ujs
//= require jquery.lwtCountdown-1.0
//= require bootstrap

$(function() {
  check_user_tipp();
  check_max_input_notice_text();

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

/**
 * Checks the maxlength of textareas and give an error, when user
 * wants to add more characters.
 */
function check_max_input_notice_text(){
  $('#notice_text').keyup(function () {
    var $this = $(this);
    var val = $this.val();
    var maxlength = $this.attr('maxlength');
    var max = parseInt(maxlength);

    var length_with_1_char_per_line_break = val.length;
    var length_with_2_chars_per_line_break = val.replace(/\n/g, "\r\n").length;
    var number_of_line_breaks = length_with_2_chars_per_line_break - length_with_1_char_per_line_break;

    if (length_with_2_chars_per_line_break > max) {
      $this.val(val.substr(0, max - number_of_line_breaks));
      alert("The maximum input length of " + max + " has been reached!");
      return false;
    } // no else

    return true;
  });
}


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







