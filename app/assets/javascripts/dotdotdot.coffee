$ ->
  $(window).resize ->
    $('.grid-item').find('.content').each ->
      add_dotdotdot $(this)

$(window).load ->
  $('.grid-item').find('.content').each ->
    add_dotdotdot $(this)

add_dotdotdot = (elem) ->
  $this = elem

  grid = $this.parents('.grid-item')
  grid_size = grid.height()

  # padding = 20

  footer = grid.find('.footer')
  footer_height = footer.height()

  top = $this.offset().top - grid.offset().top - grid.scrollTop()


  $this.dotdotdot
    ellipsis: ' [...]'
    height: grid_size - footer_height - top
