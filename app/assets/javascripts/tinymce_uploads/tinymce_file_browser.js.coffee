
this.set_amazon_direct_upload = (elem) ->
  input = $('<input>')
  input.prop 'type' : 'file'
  input.hide()
  elem.before(input)
  input.click()

  input.change ->
    $file = $(this)[0].files[0]
    $.ajax
      url: '/admin/tinymce_s3_upload/signed_urls',
      type: 'get',
      dataType: 'json',
      data:
        doc:
          title: $file.name
      success: (data) ->
        $fd = create_form_data(data, 'public-read', $file)
        $url = "https://#{data.bucket}.#{data.s3_area}.amazonaws.com/"
        $full_url = $url + data.key
        create_cors_request($fd, $url, $full_url, elem)

create_form_data = (data, acl, file) ->
  fd = new FormData()
  fd.append('key', data.key)
  fd.append('AWSAccessKeyId', data.access_key_id)
  fd.append('acl', acl)
  # fd.append('success_action_redirect', data.success_action_redirect)
  fd.append('policy', data.policy)
  fd.append('signature', data.signature)
  fd.append('Content-Type', file.type)
  fd.append('file', file)
  return fd

create_cors_request = (form_data, url, full_url, elem) ->
  document.start_loading ?= ->
    return null
  document.start_loading()

  xhr = new XMLHttpRequest()
  xhr.upload.addEventListener "progress", uploadProgress, false
  # xhr.upload.addEventListener "loadstart", uploadStarted, false
  xhr.addEventListener "load", (evt) ->
    uploadComplete full_url, elem
  , false
  xhr.addEventListener "error", uploadFailed, false
  xhr.open 'POST', url, true
  xhr.send form_data

uploadComplete = (full_url, elem) ->
  elem.val full_url
  document.stop_loading ?= ->
    return null
  document.stop_loading()

uploadProgress = (evt) ->
  if evt.lengthComputable
    percentComplete = Math.round(evt.loaded * 100 / evt.total)
  else
    alert 'upload failed'

uploadStarted = (evt) ->
  # console.log evt

uploadFailed = (evt) ->
  # console.log evt
  document.stop_loading ?= ->
    return null
  document.stop_loading()
  alert 'Ocorreu um erro.'
