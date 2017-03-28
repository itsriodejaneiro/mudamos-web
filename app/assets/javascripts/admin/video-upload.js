(function($) {
  "use strict";

  $(document).ready(function() {
    function presignedURL(file) {
      return $.post("/admin/amazon_s3_presign/video", { filename: file.name })
        .then(function(response) {
          return response.url;
        });
    }

    function uploadVideo(url, file) {
      return $.ajax({
        type: "PUT",
        url: url,
        contentType: file.type,
        processData: false,
        data: file
      })
      .then(function() {
        var fileURL = new URL(url);
        // Removes all query strings params
        fileURL.search = ""
        return fileURL.href;
      });
    }

    function onFail() {
      document.stop_loading();
      alert("Houve um erro. Tente novamente.");
    }

    $("form.video-form .video-upload").on("change", function() {
      var $form = $(this).closest("form");
      var videoFile = $(this).get(0).files[0];
      if (!videoFile) return;

      document.start_loading();

      presignedURL(videoFile)
        .then(function(url) {
          return uploadVideo(url, videoFile);
        })
        .then(function(url) {
          $form.find(".hidden-url").val(url);
          $form.trigger("submit");
        })
        .fail(onFail)
        .always(function() { document.stop_loading(); });
    });

    $("form.video-form .remove-video").on("click", function() {
      var $form = $(this).closest("form");
      $form.find(".hidden-url").val(null);
      $form.trigger("submit");
    });
  });
})(jQuery);
