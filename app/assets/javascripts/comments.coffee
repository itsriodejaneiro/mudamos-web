$ ->
  $('form[id*=new_comment]').find('button').each ->
    new_comment_button_click $(this)

new_comment_button_click = (elem) ->
  elem.click (e) ->
    e.preventDefault()

    form = $(this).parents('form:first')

    unless document.isLoggedIn

      for editor in tinyMCE.editors
        if editor.targetElm.form.id == form.attr('id')
          content = editor.getContent()

      Cookies.set 'new_comment_content', content, { expires: document.expiration_default_time }
      Cookies.set 'new_comment_is_anonymous', form.find("input[name='comment[is_anonymous]'][type='checkbox']").val(), { expires: document.expiration_default_time }
      Cookies.set 'new_comment_parent_id', form.find('input#comment_parent_id').val(), { expires: document.expiration_default_time }

      document.open_login (data) ->
        document.start_loading()
        form.submit()
    else
      document.start_loading()
      form.submit()

$ ->
  $('.load-more-comments').each ->
    add_load_more_events_to_button $(this)

str =  window.location.href
if (str.includes('?') && str.includes('comments='))
  hash = str.split('comments=')[1]
  hash = hash.split('&')[0]
  comment_ids = hash.split(',')

add_load_more_events_to_button = (elem) ->
  elem.click ->
    parent = $(this).parents('.content-area:first')
    sub = parent.children('.sub-comments')
    url = $(this).data('children-url')
    if sub.hasClass('out')
      if sub.children().length == 0
        document.start_loading()
        $.ajax url,
          type: 'GET'
          dataType: 'json'
          complete: ->
            document.stop_loading()
          error: (jqXHR, textStatus, errorThrown) ->
            alert 'Ocorreu algum erro.'
          success: (data, textStatus, jqXHR) ->
            sub.html(data.comments_html)

            sub.find('.load-more-comments').each ->
              add_load_more_events_to_button $(this)

            sub.removeClass('out')

            sub.prev('.load-more-comments').find("span").text('Esconder respostas')

            sub.find('.tinymce').each ->
              id = $(this).attr('id')
              tinymce.EditorManager.execCommand('mceAddEditor',false, id);

            sub.find('.share-comment').each ->
              prepare_share $(this)

            sub.find('form[id*=new_comment]').find('bsplitutton.new-comment-button').each ->
              new_comment_button_click $(this)

            sub.find('.like_button.toggleable').each ->
              toggleButtons($(this), 'dislike')

            sub.find('.dislike_button.toggleable').each ->
              toggleButtons($(this), 'like')

            copy_to_clipboard sub.find('.copy-to-clipboard')

            sub.slideDown 300, ->
              sub.addClass('in')

              sub.find('.readmore').each ->
                document.add_readmore_to_comment $(this)

              sub.find('.content-area').children('.content').each ->
                document.add_dotdotdot_to_comment $(this)

              if comment_ids == undefined or comment_ids == null
                return
              else
                for comment_id in comment_ids[1..-1]
                  if comment_id == comment_ids[comment_ids.length - 1]
                    last_comment = $("##{comment_id}")

                    if last_comment.length > 0
                      $('body').scrollTop(last_comment.offset().top - 120)
                      comment_ids = undefined

                      last_comment.addClass('selected-comment')
                  else
                    $("##{comment_id}").find('.load-more-comments').click()
      else
        sub.removeClass('out')
        sub.prev('.load-more-comments').find("span").text('Esconder respostas')

        sub.slideDown 300, ->
          sub.addClass('in')

    else if sub.hasClass('in')
      sub.removeClass('in')
      sub.prev('.load-more-comments').find("span").text('Ver respostas')

      sub.slideUp 300, ->
        sub.addClass('out')


$ ->
  $('.share-comment').each ->
    prepare_share $(this)

prepare_share = (elem) ->
  elem.find('.facebook').click (e) ->
    e.preventDefault()

    comment_div = $(this).parents(".reading-comment:first").parents(".row:first")
    # base_url = window.location.href
    # url = base_url + "#" + comment_div.attr('id')

    url = get_share_url comment_div

    FB.ui(
      {
        method: 'feed'
        link: url.toString()
        name: 'Você concorda com esse comentário?'
        caption: "Assunto: #{$('h1.section-title').text()}"
        description: comment_div.find('.content-area:first').find('.comment-content:first').text()
      },
      (response) ->
        if (response && !response.error_message)
          document.flash_message 'Comentário compartilhado com sucesso.', 'success'
        else
          document.flash_message 'Erro ao compartilhar comentário', 'error'
    )

  elem.click (e) ->
    e.preventDefault()

    target = $(this).find('.share_list')
    target.toggle('fast')

$ ->
  $('.like_button.toggleable ').each ->
    toggleButtons($(this), 'dislike')

  $('.dislike_button.toggleable ').each ->
    toggleButtons($(this), 'like')

toggleButtons = (obj, otherClass) ->
  obj.click ( ) ->
    error = false

    thisClass = obj.attr('class').replace(/_button toggleable/,'')

    comment_div = obj.parents(".reading-comment:first").parents(".row:first")
    commentId = comment_div.attr('id').replace(/comment-/, '')

    subject_slug = comment_div.data('subject-slug')
    cycle_slug = comment_div.data('cycle-slug')

    baseURL = "/temas/#{cycle_slug}/assuntos/#{subject_slug}/comentarios/#{commentId}"

    thisIcon = obj.children("i")
    otherIcon = obj.parents(".extra-area").find(".#{otherClass}_button i")

    thisCounter = obj.parents(".extra-area").find(".#{thisClass}_counter")
    otherCounter = obj.parents(".extra-area").find(".#{otherClass}_counter")

    thisCount = parseInt(thisCounter.text())
    otherCount = parseInt(otherCounter.text())

    if otherIcon.hasClass("toggled")
      url = "#{baseURL}/#{otherClass}/0"
      $.ajax url,
        type: 'DELETE'
        dataType: 'json'
        error: (jqXHR, textStatus, errorThrown) ->
          alert 'Ocorreu algum erro.'
          error = true
        success: (data, textStatus, jqXHR) ->
          otherIcon.toggleClass("toggled")
          otherCounter.text( ("0" + (otherCount - 1)).slice(-2) )

    if error == false
      url = "#{baseURL}/#{thisClass}"
      if thisIcon.hasClass('toggled')
        reqType = 'DELETE'
        url = url + "/0"
        delta =  -1
      else
        reqType = 'POST'
        delta =  1
      document.start_loading()
      $.ajax url,
        type: reqType
        dataType: 'json'
        complete: (data) ->
          document.stop_loading()
        error: (jqXHR, textStatus, errorThrown) ->
          alert 'Ocorreu algum erro.'
        success: (data, textStatus, jqXHR) ->
          thisIcon.toggleClass("toggled")
          thisCounter.text( ("0" + (thisCount + delta)).slice(-2) )


$ ->
  copy_to_clipboard $('a.copy-to-clipboard')

copy_to_clipboard = (elems) ->
  elems.click ->
    temp = $("<input>")
    $("body").append(temp)

    # comment_div = $(this).parents(".reading-comment:last").parents(".row:first")
    # base_url = window.location.href
    # url = base_url + "#" + comment_div.attr('id')

    url = get_share_url $(this)

    temp.val(url).select()

    document.execCommand("copy")
    temp.remove()

    document.flash_message('URL copiada.', 'success')


get_share_url = (elem) ->
  base_url = elem.parents("[data-base-url]:first").data('base-url')
  comment_share_params = elem.parents("[data-base-url]:first").data('comment-share-params')
  basic_params = $('#comments-basic-params').data('share-params')

  return (base_url + "?" + [basic_params, comment_share_params].join('&'))
