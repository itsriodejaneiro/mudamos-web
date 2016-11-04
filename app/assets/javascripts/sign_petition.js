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
    })
    .always(function() {
      location.reload();
    });
  }

  $(document).ready(function() {
    $("body").on("click", ".sign-petition", function(e) {
      e.preventDefault();

      if (isLoggedIn()) {
        signPetition();
      } else {
        document.open_login(signPetition);
      }
    });
  });

})(jQuery, document, location);
