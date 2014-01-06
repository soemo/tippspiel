//= require jquery
//= require jquery_ujs
//= require jquery.livequery
//= require jquery-migrate.min
//= require jquery.countdown
//= require bootstrap

$(function() {
  check_user_tipp();
  update_textarea_maxlength();
  ajax_load_modal_content();

  // Ranking Statistik Punkte
  $('.statistic_popover').popover({
    placement: "left",
    html: true,
    trigger: 'hover'
  });

  init_countdown('counter_desktop');
});



function init_countdown(element_id_string){
  if($('#'+element_id_string).length > 0) {
    //Countdown - DATUM des ersten Spiels
    var first_game_date_timestamp = $('#'+element_id_string).data('countdowntimestamp');
    var date = new Date(first_game_date_timestamp * 1000);

    $('#'+element_id_string).countdown({
      startTime: date,
      stepTime: 1,
      image: "assets/countdown_digits_blue.png"
    });
  }
}

// Support for AJAX loaded modal window.
// Focuses on first input textbox after it loads the window.
function ajax_load_modal_content(){

  $('[data-toggle="modal"]').click(function (e) {
    // alte div class=modal wegraeumen
    $('div.modal').remove();

    e.preventDefault();
    var href = $(this).attr('href');
    if (href.indexOf('#') == 0) {
      $(href).modal('open');
    } else {
      $.get(href,
              function (data) {
                $('<div class="modal" >' + data + '</div>').modal();
              }).success(function () {
                $('input:text:visible:first').focus();
              });
    }
  });

}

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







