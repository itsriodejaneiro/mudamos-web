#= require spin.min

opts = {
  lines: 9
  length: 15
  width: 3
  radius: 20
  corners: 0
  color: '#fff'
  opacity: 0.25
  rotate: 0
  direction: 1
  speed: 1.3
  trail: 54
  zIndex: 2e9
  className: 'spinner'
  top: 'auto'
  left: 'auto'
  shadow: false
  hwaccel: false
}

target = undefined
spinner = new Spinner(opts).spin()

$ ->
  $('body').prepend $('<div>').prop('id':'loading_overlay').css
    'width': '100%'
    'height': '100%'
    'position': 'fixed'
    'z-index': '1000000'
    'background-color': 'rgba(0,0,0,0.7)'
    'top': '0'
    'left': '0'

  target = $('#loading_overlay')
  target.append(spinner.el)

  $('.spinner').css
    left : '50%'
    top : '50%'

  target.hide()

document.start_loading = ->
  target.fadeIn('fast')

document.stop_loading = ->
  target.fadeOut('fast')

