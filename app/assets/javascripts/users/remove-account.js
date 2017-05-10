(function($, document) {
  "use strict";

  $(document).ready(function() {
    var $form = $("#remove_account_form");
    var $modal = $("#modal_remove_account");

    $("body").on("click", ".remove-account", function(e) {
      e.preventDefault();

      $modal.modal("show");
    });

    function validateForm() {
      var email = $form.find("input[type='email']").val().trim() !== "";
      var valid = email;
      $form.find("button[type=submit]").attr("disabled", !valid);
    }

    $modal.on("hidden.bs.modal", function() {
      $modal.find(".result .success, .result .error").text("");
      $modal.find(".modal-footer").addClass("hidden");
      $form.show();
    });

    $form
      .on("ajax:beforeSend", function() {
        document.start_loading();
        $(this).closest(".modal-body").find(".result .error").text("");
      })
      .on("ajax:complete", function() {
        document.stop_loading();
      })
      .on("ajax:success", function(event, data) {
        $(this).closest(".modal-body").find(".result .success").text(data.message);
        $(this).find("input[type='email']").val("");
        $modal.find(".modal-footer").removeClass("hidden");
        $form.slideUp();
      })
      .on("ajax:error", function() {
        $(this).closest(".modal-body").find(".result .error").text("Houve um erro. Por favor tente novamente mais tarde.");
      })
      .find("input[type='email']")
        .on("keyup", validateForm);
  });
})(jQuery, document);
