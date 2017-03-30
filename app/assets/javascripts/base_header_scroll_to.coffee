#= require jquery.scrollTo.min

$ ->
  $('[scroll-to]').click (e) ->
    e.preventDefault()

    elem = $($(this).attr('scroll-to'))

    headerHeight = $(".base-navbar").height()
    $.scrollTo(elem, 1000, { offset: -headerHeight })
