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


/* global $, pot */

$(document).ready(function() {
  
  function updateTimer(time) {
    if (time != 300) {
      $('#timeLeft').html("Winner drawn in " + time + " seconds, or when pot reaches 1 ether") 
    } else {
      $('#timeLeft').html("Countdown will start when at least 2 players have entered the pot")  
    }  
    if (time < 0) {
      $('#timeLeft').html("Drawing winner...")    
    }
  } 
  
  var potID ;
  var previousPotSize = 0;
  var potSize;
  var time = 300
  
  setInterval(updateTimer(time), 1000)

function update() {
    $.ajax({
        type: "POST",
        url: "/jackpot/update/" + potID,
        complete: function(response) {
          $('.live-jackpot').html(response.responseText);
          getPotInfo();
        },
        error: function(xhr, status,error) {
          console.log("Error");
        }
    });
}

function getPotID(id) {
  alert(id)
}

function ge() {
  $.ajax({
      type: "GET",
      url: "/",
      datatype: "json",
      success: function(data) {
        potID = data.potID;
        alert(potID)
      }
    });
}

function getPotInfo() {
  $.ajax({
      type: "GET",
      url: "/potinfo",
      datatype: "json",
      success: function(data) {
        potSize = data.potSize;
        console.log(potSize + " " + previousPotSize);
        updatePot(potSize, data.time)  ;
        previousPotSize = potSize;
        updateUserBalance(data.user_balance);
      },
      error: function() {
        console.log("Error getting pot info");
      }
    });  
}

});


function updateUserBalance(balance) {
  $('.user-balance').html("Ξ " + balance);
}

function updatePot(pot,time) {
  $('#pot-size').html("Ξ " + pot);
  if (time < 300) {
    $('#time-left').html("Winner drawn in " + time + " seconds, or when pot reaches 1 ether");
  } else {
    $('#time-left').html("Countdown will start when at least 2 players have entered the pot");    
  }
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
