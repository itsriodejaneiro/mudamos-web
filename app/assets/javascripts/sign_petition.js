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

      $("#modal_petition_sign").modal("show");
    });

    $(function() {
      const userAgent = navigator.userAgent || navigator.vendor;
      const GOOGLE_PLAY_URL = "https://play.google.com/store/apps/details?id=org.mudamos.petition";
      const APP_STORE_URL = "https://itunes.apple.com/br/app/mudamos/id1214485690?ls=1&mt=8";

      var $modal = $("#modal_petition_sign");

      if (/android/i.test(userAgent)) {
        $modal.find(".store-badge.app").remove();
      } else if (/iPad|iPhone|iPod/.test(userAgent) && !window.MSStream) {
        $modal.find(".store-badge.play").remove();
      }
    });

    $("form#new_petition_approver")
      .attr("action", AppRoutes.petitionApprovePath(pluginRelationId()))
      .on("ajax:beforeSend", function() {
        document.start_loading();
        $(this).closest(".modal-body").find(".result .error").text("");
      })
      .on("ajax:complete", function() {
        document.stop_loading();
      })
      .on("ajax:success", function() {
        $(this).slideUp().closest(".modal-body").find(".result .success").text("Obrigado! Agora baixe o aplicativo em uma das lojas abaixo.")
      })
      .on("ajax:error", function() {
        $(this).closest(".modal-body").find(".result .error").text("Houve um erro. Por favor tente novamente mais tarde.");
      })
      .find("input[type='email']")
        .on("keyup", function() {
          $(this).closest("form").find("button").attr("disabled", $(this).val().trim() === "");
        });
  });

})(jQuery, document, location);
