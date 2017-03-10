(function($, document, location) {
  "use strict";

  function cycleId() {
    return $("body").data("cycle");
  }

  function pluginRelationId() {
    return $("body").data("plugin-relation");
  }

  function isLoggedIn() {
    return $("body").data("logged-in");
  }

  function signPetition() {
    $.ajax({
      url: AppRoutes.cyclePluginRelationSignPath(cycleId(), pluginRelationId()),
      type: "POST"
    }).then(function() {
      location.reload();
    }).fail(function(data) {
      if (data.responseJSON.error == "user_cant_interact_with_plugin") {
        muRequireUserForm({
          fields: ["birthday"],
          success: signPetition
        });
      } else {
        location.reload();
      }
    });
  }

  $(document).ready(function() {
    $("body").on("click", ".sign-petition", function(e) {
      e.preventDefault();

      if (isLoggedIn()) {
        signPetition();
      } else {
        document.open_login(function() {
          $("#modal-session-new, #modal-registration-new").modal("hide");
          signPetition()
        });
      }
    });
  });

})(jQuery, document, location);
