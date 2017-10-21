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


/* global $, pot, jQuery */

$(document).ready(function() {
  
  $('#test-btn').click(function () {
      updateDonutChart('#specificChart', pot, true);    
  });
  
/*  function updateTimer(time) {
    if (time != "300") {
      $('#timeLeft').html("Winner drawn in " + time + " seconds, or when pot reaches 1 ether") 
    } else {
      $('#timeLeft').html("Countdown will start when at least 2 players have entered the pot")  
    }  
    if (time < 0) {
      $('#timeLeft').html("Drawing winner...")    
    }
  } */
  var potID = 0
  
  getPotID()
  
  setInterval(function() {
    getPotID()
    $.ajax({
        type: "POST",
        url: "/jackpot/update/" + potID,
        complete: function(response) {
          $('.live-jackpot').html(response.responseText);
        },
        error: function(xhr, status,error) {
          console.log("Error");
        }
    });
}, 3000);

function getPotID() {
  $.ajax({
      type: "POST",
      url: "",
      datatype: "script",
      success: function(data) {
        console.log("FACK YES POT ID IS: " + data.potID);
        potID = data.potID;
      }
    });
}
});

function updateUserBalance(balance) {
  $('.user-balance').html("Ξ " + balance);
}

function updatePot(pot, ID) {
  $('#jackpot-id').html(ID)
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

          /* OLD CODE
          console.log("pot: " + data.pot + " ether");
          var i = 0;
          if (data.winner) {
            console.log("Winner is " + data.winner.name)
            console.log("Players:")
            $(jQuery.parseJSON(data.players)).each(function() {  
                console.log(this.name)
            });
          }
          updatePot(data.pot, potID);
          updateUserBalance(data.user_balance);
          timeLeft = data.time;
        */