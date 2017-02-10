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

  function canUserInteract() {
    return $("#petition-index").data("can-user-interact");
  }

  function signPetition() {
    var sign = function() {
      $.ajax({
        url: AppRoutes.cyclePluginRelationSignPath(cycleId(), pluginRelationId()),
        type: "POST"
      })
      .always(function() {
        location.reload();
      });
    };

    if (canUserInteract()) {
      sign();
    } else {
      muRequireUserForm({
        fields: ["birthday"],
        success: sign
      });
    }
  }

  $(document).ready(function() {
    $("body").on("click", ".sign-petition", function(e) {
      e.preventDefault();

      if (isLoggedIn()) {
        signPetition();
      } else {
        document.open_login(function() {
          signPetition();
        });
      }
    });
  });

})(jQuery, document, location);
