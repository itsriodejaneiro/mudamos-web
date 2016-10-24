root = exports ? this

root.initTinyMCE = (class_name) ->
  tinyMCE.init
    selector: ".#{class_name}"
    plugins: [
      "autolink lists link image preview anchor",
      "fullscreen hr code visualblocks visualchars",
      "table paste"
    ],
    file_browser_callback: (field_name, url, type, win) ->
      root.set_amazon_direct_upload $('#' + field_name)
    , toolbar: "undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image"

