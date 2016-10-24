$ ->
  $('input.cpf_mask').each ->
    window.cpfy_input $(this)

$ ->
  $('.button.has_many_add').click ->
    parent = $(this).parents('.has_many_container')
    window.delay 10, ->
      parent.find('.inputs:last').find('input.cpf_mask').each ->
        window.cpfy_input $(this)

$ ->
  $('#bank_details').on 'cocoon:after-insert', (e, insertedItem) ->
    window.cpfy_input(insertedItem.find('.cpf_mask'))

window.cpfy_input = (elem) ->
  turn_to_cpf elem
  elem.keyup (e) ->
    if $.inArray(e.keyCode, [8, 37, 38, 39, 40, 46]) == -1
      turn_to_cpf elem

turn_to_cpf = (elem) ->
  numbers = elem.val().replace(/\D/g, '').slice(0,11)

  if numbers.length >= 9
    numbers = [numbers.slice(0,3), '.', numbers.slice(3, 6), '.', numbers.slice(6, 9), '-', numbers.slice(9)].join('')
  else if numbers.length >= 6
    numbers = [numbers.slice(0,3), '.', numbers.slice(3, 6), '.', numbers.slice(6)].join('')
  else if numbers.length >= 3
    numbers = [numbers.slice(0,3), '.', numbers.slice(3)].join('')

  elem.val numbers
