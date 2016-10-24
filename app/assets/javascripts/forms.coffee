$ ->
  $('input').keyup ->
    this.setAttribute('value', this.value)

document.set_errors = (errors, form, model = "user") ->
  $.each errors, (k, v) ->
    elem = form.find("##{model}_#{k}")
    parent = elem.parents('li:first')

    if parent.hasClass('input') and parent.next('.file-input-image').length == 1
      parent = parent.parents('.file-input-image-container:first')

    parent.addClass('error')

    error = parent.find('p.inline-errors')
    if error.length == 0
      parent.append $("<p class='inline-errors' style='display: none'></p>")
      error = parent.find('p.inline-errors')

    error.text(document.capitalizeFirstLetter(v[0]))
    error.slideDown(300)

    elem.focus ->
      parent.removeClass('error')
      error.slideUp 300, ->
        $(this).remove()

    elem.change ->
      parent.removeClass('error')
      error.slideUp 300, ->
        $(this).remove()
