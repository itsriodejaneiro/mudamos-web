$ ->
  bar = $('.cycles-index').find('nav.navbar.navbar-default.navbar-fixed-top')
  notify_length = $('.notification-dropdown li').length;
  if notify_length == 1
    bar.find('.notification-dropdown').css('top','-82px')
  else if notify_length == 2
    bar.find('.notification-dropdown').css('top','-163px')
  else if notify_length == 3
    bar.find('.notification-dropdown').css('top','-243px')
  else
    bar.find('.notification-dropdown').css('top','-325px')

  if bar.length > 0
    offset = parseInt(bar.position().top)

    sticky = new Waypoint.Sticky
      element: bar[0]
      offset: -offset
      # handler: (direction) ->
      #   if direction == 'down'
      #     bar.find('.search').animate
      #       opacity: 1
      #   else
      #     bar.find('.search').animate
      #       opacity: 0

    new Waypoint
      element: bar[0],
      offset: offset / 2,
      handler: (direction) ->
        if direction == 'down'
          bar.find('.dropdown').removeClass('dropup')
          bar.find('.notification-dropdown').css('top','60px')
        else if notify_length == 1
          bar.find('.dropdown').addClass('dropup')
          bar.find('.notification-dropdown').css('top','-82px')
        else if notify_length == 2
          bar.find('.dropdown').addClass('dropup')
          bar.find('.notification-dropdown').css('top','-163px')
        else if notify_length == 3
          bar.find('.dropdown').addClass('dropup')
          bar.find('.notification-dropdown').css('top','-243px')
        else
          bar.find('.dropdown').addClass('dropup')
          bar.find('.notification-dropdown').css('top','-325px')