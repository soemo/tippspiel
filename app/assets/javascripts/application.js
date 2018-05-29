//= require jquery
//= require jquery_ujs
//= require jquery.livequery
//= require foundation
//= require chart.min
//= require jquery.mixitup.min
//= require are-you-sure.jquery
//= require ays-beforeunload-shim


$(function(){
  $(document).foundation();

  initScrollToTop();
  initCheckTippChanges();
  updateTextareaMaxlength();
  repositionOfFlashMessages();
  repositionOfFlashMessagesIfOneIsClosed();
  autoCloseSuccessMessage();

  check_user_tip();
  init_random_user_tips();

  // https://github.com/patrickkunka/mixitup/blob/master/docs/configuration-object.md
  $('#mixitup-table').mixItUp({
    layout: {
      display: 'table-row'
    },
    animation: {
      enable: false
    }
  });
});

function initCheckTippChanges(){
  // https://github.com/codedance/jquery.AreYouSure - alerts users to unsaved changes
  $('form#js_save_tips').areYouSure();

  $('form#js_save_tips').on('dirty.areYouSure', function() {
    $('#scroll-to-tipp-save-button').fadeIn();
  });
  $('form#js_save_tips').on('clean.areYouSure', function() {
    $('#scroll-to-tipp-save-button').fadeOut();
  });
}


function initScrollToTop(){

  $(window).scroll(function () {
    if ($(this).scrollTop() > 100) {
      $('#scroll-to-top').fadeIn();
    } else {
      $('#scroll-to-top').fadeOut();
    }
  });

  $('#scroll-to-top').click(function () {
    $("html, body").animate({
      scrollTop: 0
    }, 200);
    return false;
  });
}

function updateTextareaMaxlength(){
  var onEditCallback = function (remaining) {
    $(this).siblings("div").children('.js_chars_remaining').text(remaining);

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
      .livequery('input paste', onEdit);
}


// die Flash-Popup Meldungen werden anhand der Navbar ausgerichtet
// die erste Meldung ist rechtsbuendig auf Hoehe der Brandbar ausgerichtet
// alle Weiteren werden direkt unter der Vorherigen angezeigt
function repositionOfFlashMessages(){
  var flash_messages = $("div.alert-box");
  return flash_messages.livequery(function() {
    var container, containerLeft, containerTop, lastBottom;
    if (flash_messages.length > 0) {
      containerLeft = $("div#main-content").offset().left;
      containerTop = $("div#hero-div").offset().top + 10;
      lastBottom = containerTop;
      return flash_messages.each(function(index) {
        var top;
        top = lastBottom;
        //$(this).css("right", containerLeft);
        $(this).css("top", top);
        $(this).show();
        return lastBottom = lastBottom + $(this).outerHeight();
      });
    }
  });
}

// wenn eine Flash-Meldung verschwindet, sollten die Meldungen darunter hochrutschen
function repositionOfFlashMessagesIfOneIsClosed(){
  var dom_flash_messages_close = "div.alert-box button.close";
  var dom_flash_messages_name  = "div.alert-box";

  $(dom_flash_messages_close).click(function() {
    var closed_element_flash_message = $(this).parent();
    var closed_element_height        = closed_element_flash_message.outerHeight();
    var index                        = $(dom_flash_messages_name).index(closed_element_flash_message);

    // alle nachfolgenden Flash-Meldungen hochrutschen lassen
    var elements = $(dom_flash_messages_name+":gt("+index+")");
    if(elements.length > 0){
      elements.each(function() {
        $(this).css("top", $(this).offset().top - closed_element_height);
      });
    }

  });
}

function autoCloseSuccessMessage(){
  // Blendet alert-success Messages nach x Sekunden aus
  var elem = $("div.alert-box.success")
  return elem.livequery(function() {
    return setTimeout((function() {
      return elem.fadeOut("slow", function() {
        $(this).children("button.close").first().trigger("click");
        return $(this).remove();
      });
    }), 5000);
  });
}

function check_user_tip() {
  $(".tip_input").keyup( function() {
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

function init_random_user_tips(){
  $('#js_fill_random_tips').click(function() {
    var inputs =  $(".tip_input:visible:not(:disabled)");
    if(inputs.length) {
      $.each(inputs, function() {
        $(this).val(Math.floor((Math.random() * 6))); // von 0 - 5 per Zufall eintragen
      });
    }
    return false; // damit danach kein GET ausgeloest wird
  });
}

