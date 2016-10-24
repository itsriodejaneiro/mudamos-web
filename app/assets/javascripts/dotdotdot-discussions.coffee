$(window).load ->
  set_dotdotdot()
  set_owl()
# document.delay 2000, set_owl

set_owl = ->
  $('.discussion-widget').owlCarousel
    items: 1
    loop: true
    center: true
    nav: true
    dots: true
    navText: ['&#x27','','&#x27','']

set_dotdotdot = ->
  $('.discussion-widget').find('.subject-card').find('.comment').find('.content').each ->
    $(this).dotdotdot
      ellipsis: ' [...]'

  $(window).resize ->
    $('.discussion-widget').find('.subject-card').find('.comment').find('.content').each ->
      $(this).dotdotdot
        ellipsis: ' [...]'
