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
#= require parallax.min
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
#= require owl.carousel.min
#= require bootstrap_and_overrides
#= require masonry.pkgd.min
#= require dotdotdot
#= require dotdotdot-blogpost
#= require tinymce
#= require tinymce-jquery
#= require tinymce_uploads/tinymce_file_browser
#= require tinymce_uploads/tinymce_initializer
#= require_self
#= require inputs/date_mask
#= require inputs/image_upload
#= require users/login
#= require dotdotdot-comments
#= require comments
#= require search
#= require vocabulary-modal
#= require grid-item
#= require next-subject
#= require notification
#= require highcharts
#= require pattern-fill
#= require reports

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
  $('select').each ->
    placeholder = $(this).find('option').eq(0).text()

    if $(this).data('search-disabled') == true
      $(this).select2
        placeholder: placeholder
        minimumResultsForSearch: -1
    else
      $(this).select2
        placeholder: placeholder
