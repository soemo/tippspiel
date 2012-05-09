//= require jquery
//= require jquery_ujs
//= require jquery.lwtCountdown-1.0
//= require bootstrap

$(function() {
  check_user_tipp();
  update_textarea_maxlength();

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

function update_textarea_maxlength(){
  var onEditCallback = function (remaining) {
    $(this).siblings("p").children('.js_chars_remaining').text(remaining);

    if (remaining > 0) {
      $(this).css('background-color', 'white');
    }
  }

  var onLimitCallback = function () {
    //$(this).css('background-color', 'red');
  }

  $('textarea[maxlength]').limitMaxlength({
    onEdit:onEditCallback,
    onLimit:onLimitCallback
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

// http://that-matt.com/2010/04/updated-textarea-maxlength-with-jquery-plugin/
jQuery.fn.limitMaxlength = function (options) {

  var settings = jQuery.extend({
    attribute:"maxlength",
    onLimit:function () {
    },
    onEdit:function () {
    }
  }, options);

  // Event handler to limit the textarea
  var onEdit = function () {
    var textarea = jQuery(this);
    var maxlength = parseInt(textarea.attr(settings.attribute));

    if (textarea.val().length > maxlength) {
      textarea.val(textarea.val().substr(0, maxlength));

      // Call the onlimit handler within the scope of the textarea
      jQuery.proxy(settings.onLimit, this)();
    }

    // Call the onEdit handler within the scope of the textarea
    jQuery.proxy(settings.onEdit, this)(maxlength - textarea.val().length);
  }

  this.each(onEdit);

  return this.keyup(onEdit)
          .keydown(onEdit)
          .focus(onEdit)
          .live('input paste', onEdit);
}







