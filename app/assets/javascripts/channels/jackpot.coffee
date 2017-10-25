App.jackpot = App.cable.subscriptions.create "JackpotChannel",
  connected: ->
    # Called when the subscription is ready for use on the server

  disconnected: ->
    # Called when the subscription has been terminated by the server

  received: (data) ->
      x = data.users.length - 1
      console.log(x)
      $('#players-table').show()
      $('#pot-size').html('Ξ ' + data.pot.pot)
      add_row(data.user, data.stake, data.winchance)
      
      updateDonutChart('#jackpot-doughnut', data.pot.pot * 100 , true)

add_row = (user, stake, winchance) ->
  $('#players-table-body').append '<tr>' + 
        '<td>' + user.name + '</td>' + 
        '<td>' + stake + '</td>' + 
        '<td>' + winchance + '</td>'  




updateDonutChart = (el, percent, donut) ->
  percent = Math.round(percent)
  if percent > 100
    percent = 100
  else if percent < 0
    percent = 0
  deg = Math.round(360 * percent / 100)
  if percent > 50
    $(el + ' .pie').css 'clip', 'rect(auto, auto, auto, auto)'
    $(el + ' .right-side').css 'transform', 'rotate(180deg)'
  else
    $(el + ' .pie').css 'clip', 'rect(0, 1em, 1em, 0.5em)'
    $(el + ' .right-side').css 'transform', 'rotate(0deg)'
  if donut
    $(el + ' .right-side').css 'border-width', '0.1em'
    $(el + ' .left-side').css 'border-width', '0.1em'
    $(el + ' .shadow').css 'border-width', '0.1em'
  else
    $(el + ' .right-side').css 'border-width', '0.5em'
    $(el + ' .left-side').css 'border-width', '0.5em'
    $(el + ' .shadow').css 'border-width', '0.5em'
  $(el + ' .num').text percent
  $(el + ' .left-side').css 'transform', 'rotate(' + deg + 'deg)'
  return