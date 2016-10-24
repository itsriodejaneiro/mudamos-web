DEFAULT_AFTER_URL = null

$ ->
  document.isLoggedIn = ($('body').data('logged-in') == 'true' or $('body').data('logged-in') == true)

  DEFAULT_AFTER_URL = Cookies.get('after_login_path')
  DEFAULT_AFTER_URL ||= '/'

  document.afterLoginFunc = ->
    document.redirect_to DEFAULT_AFTER_URL

document.open_login = (func = null) ->
  $('#modal-session-new').modal 'show'
  # $('#modal-registration-new').modal 'show'

  if func != null
    document.afterLoginFunc = func
  else
    document.afterLoginFunc = ->
      location.reload()
      # document.redirect_to DEFAULT_AFTER_URL

document.open_forgot_password = (func = null) ->
  $('#modal-passwords-new').modal 'show'  

$ ->
  state_select = $('select#user_state')
  city_select = $('select#user_city')

  state_select.change ->
    city_select.parents("li:first").slideUp()
    url = "/#{$(this).val()}/cities"
    document.start_loading()
    $.ajax
      url: url,
      type: 'GET',
      dataType: 'json'
      complete: ->
        document.stop_loading()
      success: (data) ->
        city_select.val('')
        city_select.find('option').remove()
        city_select.append($("<option value=''>Cidade</option>"))
        for city in data.cities
          city_select.append($("<option value='#{city}'>#{city}</option>"))

        city_select.parents("li:first").slideDown()

$ ->
  profile_select = $('select#user_profile_id')
  profile_description = $('form#new_user').find('.profile-description')
  sub_profile_select = $('select#user_sub_profile_id')
  sub_profile_description = $('form#new_user').find('.sub-profile-description')

  profile_select.change ->
    profile_description.slideUp()
    sub_profile_description.slideUp()
    sub_profile_select.parents("li:first").slideUp()
    url = "/#{$(this).val()}/profiles"

    document.start_loading()
    $.ajax
      url: url,
      type: 'GET',
      dataType: 'json'
      complete: ->
        document.stop_loading()
      success: (data) ->
        sub_profile_select.val('')
        sub_profile_select.find('option').remove()
        if data.description
          profile_description.text(data.description)
          profile_description.slideDown()
        if data.profiles.length > 0
          sub_profile_select.append($("<option value=''>Sub Setor de Atuação</option>"))
          for profile in data.profiles
            sub_profile_select.append($("<option value='#{profile[1]}'>#{profile[0]}</option>"))

          sub_profile_select.change ->
            sub_profile_description.slideUp()
            for profile in data.profiles
              if parseInt($(this).val()) == parseInt(profile[1]) and profile[2]
                sub_profile_description.text(profile[2])
                sub_profile_description.slideDown()

          sub_profile_select.parents("li:first").slideDown()

$ ->
  current = 0
  options = $('.alias-options').find('option')

  $('button.alias-button').click (e) ->
    e.preventDefault()
    e.stopPropagation()

    current = current + 1
    if current == options.length
      current = 0

    name = options.eq(current).text()

    $('.alias-name').find('span.big').text(name)
    $('input#user_alias_name').val(name)

$ ->
  $('.modal').each ->
    $(this).find('form[id*=user]').each ->
      form = $(this)

      form.find('button[type="submit"]').click ->
        document.start_loading()

      unless form.parents('[id*=passwords]:first').length
        form.on 'ajax:success', (evt, data, status, xhr) ->
          document.stop_loading()
          if data.csrf_token
            Cookies.set('clear_after_login_path', true, { expires: document.expiration_default_time })
            refreshCSRFToken data
            document.afterLoginFunc data

        form.on 'ajax:remotipartComplete', (e, data) ->
          document.stop_loading()
          if data.csrf_token
            Cookies.set('clear_after_login_path', true, { expires: document.expiration_default_time })
            refreshCSRFToken data
            document.afterLoginFunc data

    $('.social-login').find('a').click ->
      Cookies.set 'controller', $('body').data('controller'), { expires: document.expiration_default_time }
      Cookies.set 'action', $('body').data('action'), { expires: document.expiration_default_time }
      Cookies.set 'cycle', $('body').data('cycle'), { expires: document.expiration_default_time }
      Cookies.set 'subject', $('body').data('subject'), { expires: document.expiration_default_time }
      Cookies.set 'after_login_path', location.href, { expires: document.expiration_default_time }

refreshCSRFToken = (data) ->
  if data.hasOwnProperty 'csrf_token'
    $('meta[name="csrf-token"]').attr 'content', data.csrf_token
    $('form').each ->
      $(this).find('input[name="authenticity_token"]').val data.csrf_token

$(document).load ->
  Cookies.remove('after_login_path')
