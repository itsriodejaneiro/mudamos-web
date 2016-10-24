# This is a manifest file that'll be compiled into application.js, which will include all the files
# listed below.
#
# Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
# or any plugin's vendor/assets/javascripts directory can be referenced here using a relative path.
#
# It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
# compiled file.
#
# Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
# about supported directives.
#
#= require jquery
#= require jquery_ujs
#= require jquery.remotipart
#= require loading
#= require jquery.waypoints.min
#= require select2
#= require select2_locale_pt-BR
#= require sticky.min
#= require jquery.dotdotdot.min
#= require js.cookies
#= require exif
#= require load-image.min
#= require flash_messages
#= require forms
#= require modal
#= require bootstrap_and_overrides
#= require dotdotdot
#= require dotdotdot-blogpost
#= require tinymce
#= require tinymce-jquery
#= require tinymce_uploads/tinymce_file_browser
#= require tinymce_uploads/tinymce_initializer
#= require_self
#= require inputs/date_mask
#= require inputs/image_upload
#= require notification
#= require highcharts.js
#= require admin/bootstrap-datepicker.min.js
#= require admin/bootstrap-datepicker.pt-BR.min.js
#= require admin/admin.js
#= require cocoon
#= requite admin/notification.js

document.expiration_default_time = 300

document.delay = (ms, func) ->
  setTimeout(func,  ms)

document.redirect_to = (url) ->
  window.location.replace url

document.capitalizeFirstLetter = (string) ->
  string.charAt(0).toUpperCase() + string.slice(1)

mousescrollfix = (elem) ->
  elem.bind 'mousewheel DOMMouseScroll', (e) ->
    scrollTo = undefined

    if e.type == 'mousewheel'
      scrollTo = (e.originalEvent.wheelDelta * -1)

    else if e.type == 'DOMMouseScroll'
      scrollTo = 40 * e.originalEvent.detail

$ ->
  $('select').not('.select2-disabled').each ->
    placeholder = $(this).find('option').eq(0).text()

    options = {
      placeholder: placeholder,
      allowClear: true
    }

    if $(this).data('search-disabled') == true
      options['minimumResultsForSearch'] = -1

    if $(this).data('icon-select') == true
      options['templateResult'] = formatState
      options['templateSelection'] = formatState

    if $(this).data('tags') == true
      options['tags'] = true
    
    $(this).select2 options


formatState = (opt) ->
  if opt.text
    return $("<i class='#{opt.text}'>")
  else
    opt.text

$ ->
  $('select.select-actions').not('#bulk-actions').change ->
    select = this
    method = $(this).children("[value='" + $(this).val() + "']").attr('method')

    if method == '' or method == undefined
      method = 'get'
    

    if method == 'delete'
      r = confirm('Você tem certeza?')
    else
      r = true

    return unless r

    document.start_loading()

    if $(this).val() != "" and method == 'get'
      window.location.href = $(this).val()
    else if method == 'modal'
      html = $.ajax
        type: 'GET'
        url: $(this).val()
        success: (data) ->
          $('#dynamic-modal').find('.modal-content').html(data)
          $('#dynamic-modal').modal('show')
          select.selectedIndex = 0
        complete: ->
          document.stop_loading()
    else
      $.ajax
        type: method,
        url: $(this).val()
        complete: ->
          window.location.reload()


$ ->
  $('#bulk-actions').change ->
    select = this
    method = $(this).children("[value='" + $(this).val() + "']").attr('method')

    if method == '' or method == undefined
      method = 'get'

    ids = []
    $(select).parents('.filters:first').next('table').find('input.check_box[data-id]:checked').each ->
      ids.push $(this).data('id')


    if $(this).val() != "" and method == 'get'
      document.start_loading()
      window.location.href = $(this).val()
    else if $(this).val() != ""
      document.start_loading()
      $.ajax
        type: method,
        url: $(this).val()
        data:
          ids: ids
        complete: ->
          window.location.reload()

$ ->
  $("#bulk-checkbox").change ->
    $(".check_box").prop('checked', $(this).prop("checked"))

$ ->
  tinyMCE.init
    selector: ".setting-tinymce"
    plugins: [
      "autolink lists link table paste"
    ]
    menubar: false
    paste_as_text: true
    toolbar: "bold italic underline | bullist numlist | link"
