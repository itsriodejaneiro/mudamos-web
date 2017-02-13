(function($) {
  window.muRequireUserForm = function(opts) {
    opts = opts || {};
   
    var fields = opts.fields;
    var success = opts.success;

    if (!fields || fields.length == 0) throw "At least one field is required";

    $.get("/users/me").then(function(user) {
      var $form = $(JST["templates/mu.require-user-form"]({
        fields: fields,
        user: user
      }));

      $form.muModal({
        title: "Preencha seus dados para continuar"
      });

      $form.on("click", ".cancel", function() {
        $form.muModal("hide");
      });

      $form.on("click", ".continue", function() {
        var data = { user: {}, fields: []};

        $form.find("input,select").each(function() {
          var $me = $(this);
          if ($me.is(":visible")) {
            var field = $me.prop("name");
            data.user[field] = $me.val() || null;
            data.fields.push(field);
          }
        });

        $.ajax({
          url: "/users/" + user.id,
          type: "PUT",
          contentType: "application/json",
          data: JSON.stringify(data),
          success: function() {
            $form.muModal("hide");
            if (success) success();
          },
          error: function(data) {
            $.each(data.responseJSON.missing_fields, function(idx, field) {
              $form.find("[name=" + field + "]").closest("div").find("h3").css("color", "#ad0000");
            });
            document.flash_message("Todos os campos são obrigatórios", "error");
          }
        });
      });

      $form.muModal("show");
    });
  };
})(jQuery);
