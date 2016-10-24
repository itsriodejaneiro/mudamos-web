$ ->
  $(window).scroll ->
    elem = $('.full-background-image.blur')

    if $(document).scrollTop() > ($(window).height() / 3)
      opacity = 1
    else
      opacity = $(document).scrollTop() / ($(window).height() / 3)

    elem.css
      'opacity' : opacity
