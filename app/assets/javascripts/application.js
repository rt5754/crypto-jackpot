// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file.
//
// Read Sprockets README (https://github.com/sstephenson/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require jquery
//= require jquery_ujs
//= require turbolinks
//= require bootstrap-sprockets
//= require_tree .


/* global $, pot, gon */

$(document).ready(function() {
  
  $('#test-btn').click(function () {
      updateDonutChart('#specificChart', pot, true);    
  });
  
  var currentUrl = window.location.href;
  var potID = 0;
  
  getPotID()
  setInterval(getPotID(),10000);
  
  
  setInterval(function() {
    $.ajax({
        type: "POST",
        url: "/jackpot/update/" + potID,
        datatype: "json",
        success: function(data) {
          console.log("pot: " + data.pot);
          updatePot(data.pot);
          updateUserBalance(data.user_balance);
        },
        error: function() {
          console.log("FUCKsake")
        }
    });
}, 3000);

function getPotID() {
  $.ajax({
      type: "GET",
      url: "",
      datatype: "json",
      success: function(data) {
        console.log("FACK YES");
        potID = data.potID;
      }
    });
}
});

function updateUserBalance(balance) {
  $('.user-balance').html("Ξ " + balance);
}

function updatePot(pot) {
  $('#potSize').html("Ξ " + Number(pot).toFixed(8))
  updateDonutChart('#jackpot-doughnut', pot * 100 , true); 
}

function updateDonutChart (el, percent, donut) {
    percent = Math.round(percent);
    if (percent > 100) {
        percent = 100;
    } else if (percent < 0) {
        percent = 0;
    }
    var deg = Math.round(360 * (percent / 100));

    if (percent > 50) {
        $(el + ' .pie').css('clip', 'rect(auto, auto, auto, auto)');
        $(el + ' .right-side').css('transform', 'rotate(180deg)');
    } else {
        $(el + ' .pie').css('clip', 'rect(0, 1em, 1em, 0.5em)');
        $(el + ' .right-side').css('transform', 'rotate(0deg)');
    }
    if (donut) {
        $(el + ' .right-side').css('border-width', '0.1em');
        $(el + ' .left-side').css('border-width', '0.1em');
        $(el + ' .shadow').css('border-width', '0.1em');
    } else {
        $(el + ' .right-side').css('border-width', '0.5em');
        $(el + ' .left-side').css('border-width', '0.5em');
        $(el + ' .shadow').css('border-width', '0.5em');
    }
    $(el + ' .num').text(percent);
    $(el + ' .left-side').css('transform', 'rotate(' + deg + 'deg)');
}

//Ignore the rest, it's for the input and checkbox

$('#percent').change(function () {
    var percent = $(this).val();
    var donut = $('#donut input').is(':checked');
    updateDonutChart('#specificChart', percent, donut);
}).keyup(function () {
    var percent = $(this).val();
    var donut = $('#donut input').is(':checked');
    updateDonutChart('#specificChart', percent, donut);
});;

$('#donut input').change(function () {
    var donut = $('#donut input').is(':checked');
    var percent = $("#percent").val();
    if (donut) {
        $('#donut span').html('Donut');
    } else {
        $('#donut span').html('Pie');
    }
    updateDonutChart('#specificChart', percent, donut);
});




