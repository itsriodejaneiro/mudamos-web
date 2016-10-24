$ ->
  $('input.date_mask').each ->
    window.datefy_input $(this)

$ ->
  $('.button.has_many_add').click ->
    parent = $(this).parents('.has_many_container')
    window.delay 10, ->
      parent.find('.inputs:last').find('input.date_mask').each ->
        window.datefy_input $(this)

window.datefy_input = (elem) ->
  turn_to_date elem
  elem.keyup (e) ->
    if $.inArray(e.keyCode, [8, 37, 38, 39, 40, 46]) == -1
      turn_to_date elem

turn_to_date = (elem) ->
  numbers = elem.val().replace(/\D/g, '').slice(0,8)
  if numbers.length >= 4
    numbers = [numbers.slice(0, 2), '/', numbers.slice(2, 4), '/', numbers.slice(4)].join('')
  else if numbers.length >= 2
    numbers = [numbers.slice(0, 2), '/', numbers.slice(2)].join('')

  elem.val numbers
