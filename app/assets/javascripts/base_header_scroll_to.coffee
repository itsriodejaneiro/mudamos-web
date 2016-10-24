#= require jquery.scrollTo.min

$ ->
  $('[scroll-to]').click (e) ->
    e.preventDefault()

    elem = $($(this).attr('scroll-to'))

    $.scrollTo(elem, 1000)
