flash_timeout = undefined
document.animation_speed = 300
document.delay_time = 7000

document.flash_message = (message, class_type) ->
  return if message == null or message == '' or message == undefined

  document.clear_flashes()

  unless flash_timeout == undefined
    clearTimeout flash_timeout

  flash = $('<div>').addClass("flash_message flash_#{class_type}").append($("<div>").addClass('container').html message)
  add_events_to_message flash

  $('body').prepend flash
  flash.stop().slideDown document.animation_speed

add_events_to_message = (elem) ->
  elem.click ->
    document.flash_out $(this)

  flash_timeout = document.delay document.delay_time
  , ->
    document.flash_out elem

  elem.mouseover ->
    clearTimeout flash_timeout

  elem.mouseout ->
    flash_timeout = document.delay document.delay_time
    , ->
      document.flash_out elem

document.flash_out = (elem) ->
  elem.stop().slideUp document.animation_speed
  , ->
    $(this).remove()

document.clear_flashes = ->
  $('.flash_message').stop().slideUp document.animation_speed
