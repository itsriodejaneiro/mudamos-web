$ ->
  $(".grid-item").click (e) ->
    e.preventDefault()
    e.stopPropagation()

    link = $(this).find("a")

    if link.attr('target') == '_blank'
      win = window.open(link.attr("href"), "_blank")
      if win
        win.focus()
      else
        alert "Please allow popups for this site"
    else
      location.href = link.attr('href')
