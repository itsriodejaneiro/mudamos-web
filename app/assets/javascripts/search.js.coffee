search_in = false

$ ->
  $('nav.navbar').find('.search').find('a').click (e) ->
    e.stopPropagation()
    e.preventDefault()
    if parseInt($(this).parents('.search:first').css('opacity')) == 1
      unless search_in
        bring_in_search_bar()
      else
        bring_out_search_bar()

  search()

  $('.search-bar').find('.close').click ->
    bring_out_search_bar()

bring_in_search_bar = ->
  $('.search-bar').slideDown 'fast', ->
    search_in = true
    $('.search-bar').find('input').focus()

bring_out_search_bar = ->
  $('.search-bar').slideUp 'fast', ->
    search_in = false

  $('.search-bar').find('input').focusout()
  $('.search-bar').find('input').val('')

  $('body').css 'overflow-y' : 'auto'
  $('.search-results').fadeOut 'fast', ->
    $('.search-results').html('')
    $('.search-bar').removeClass('small') if $('.search-bar').hasClass('small')

countdown = undefined

search = ->
  input = $('.search-bar').find('input')

  if input.length > 0
    input.keyup ->
      countdown = document.delay(1000, make_the_search)

    input.keydown ->
      clearTimeout(countdown)

make_the_search = ->
  unless countdown == undefined
    countdown = undefined
    value = $('.search-bar').find('input').val()

    document.start_loading()

    $.ajax '/busca',
      type: 'GET'
      dataType: 'html'
      data:
        search: value
      complete: ->
      error: (jqXHR, textStatus, errorThrown) ->
        document.stop_loading()
        alert 'Ocorreu algum erro.'
      success: (data, textStatus, jqXHR) ->
        results = $('.search-results')

        $('body').css 'overflow' : 'hidden'

        # nav_height = $('nav.navbar').outerHeight()
        # results.css 'padding-top' : "#{nav_height}px"

        results.html(data)

        $('.search-content').find('.close-search').click ->
          bring_out_search_bar()

        $('.search-bar').addClass('small') unless $('.search-bar').hasClass('small')

        navbar_height = $('nav.navbar.navbar-default.navbar-fixed-top').height()

        $('.search-results').css
          height: "#{$(window).height() - (navbar_height)}px"

        document.stop_loading()
        results.fadeIn 'fast', ->
          tab = results.find('.blog-bottom-area:first').parents('.tab-pane:first')

          is_active = tab.hasClass('active')

          unless is_active
            tab.addClass('active')

          tab.find('.blog-bottom-area').dotdotdot
            ellipsis: ' [...]'

          unless is_active
            tab.removeClass('active')
