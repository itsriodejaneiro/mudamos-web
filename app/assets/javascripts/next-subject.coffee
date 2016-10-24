$ ->
  next_subject = $('.next_subject')

  if next_subject.length > 0
    offset = parseInt(next_subject.position().top - $('.navbar').height())

    sticky = new Waypoint.Sticky
      element: next_subject[0]
      offset: '50%'
      handler: (direction) ->
        elem = $($(this)[0].element)

        if direction == 'down'
          elem.css
            width: elem.parent().width()
        else
          elem.css
            width: 'auto'


$ ->
  $('.next_subject').click (e) ->
    e.preventDefault()
    id = $(this)[0].id
    window.location.href = id
