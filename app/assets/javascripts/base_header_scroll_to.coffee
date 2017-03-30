#= require jquery.scrollTo.min

$ ->
  $('[scroll-to]').click (e) ->
    e.preventDefault()

    elem = $($(this).attr('scroll-to'))

    $navBar = $(".base-navbar")
    headerHeight = if $navBar.hasClass("stuck") then -$navBar.height() else 20
    $.scrollTo(elem, 1000, { offset: headerHeight })
