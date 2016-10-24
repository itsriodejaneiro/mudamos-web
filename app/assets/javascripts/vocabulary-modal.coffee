$ ->
  $('.vocabulary-modal').click ->
    subject_id = $(this).data('subject-id')
    cycle_id = $(this).data('cycle-id')

    url = "/temas/#{cycle_id}/assuntos/#{subject_id}"

    document.start_loading()
    $.ajax url,
      type: 'GET'
      dataType: 'json'
      complete: ->
        document.stop_loading()
      success: (data, textStatus, jqXHR) ->
        modal = $('#subject-description')

        modal.find('.modal-content').html data.html

        modal.modal 'show'