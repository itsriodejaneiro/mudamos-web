(function($) {
  window.muRequireUserForm = function(opts) {
    var opts = opts || {};
   
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
        var data = {};

        $form.find("input,select").each(function() {
          var $me = $(this);
          data[$me.prop("name")] = $me.val();
        });

        $.ajax({
          url: "/users/" + user.id,
          type: "PUT",
          contentType: "application/json",
          data: JSON.stringify({ user: data, fields: fields }),
          success: function() {
            if (success) success();
          }
        });
      });

      $form.muModal("show");
    });
  };
})(jQuery);
