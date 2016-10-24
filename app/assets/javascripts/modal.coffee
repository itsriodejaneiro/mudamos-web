$ ->
  $('.modal').on 'show.bs.modal', ->
    $this = $(this)
    id = $(this).attr 'id'
    
    $('.modal').each ->
      unless id == $(this).attr('id') or !$(this).hasClass('in')
        $(this).addClass('hiding-modal')
        $(this).modal('hide')
        $(this).on 'hidden.bs.modal', ->
          if $(this).hasClass('hiding-modal')
            $('body').addClass('modal-open')
