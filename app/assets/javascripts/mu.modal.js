(function($) {
  $.fn.muModal = function(opts) {
    var opts = opts || {};

    if (opts == "show") {
      $(this).closest(".mu-modal").show();
      $(".mu-modal-overlay").show();
      return;
    } else if (opts == "hide") {
      $(this).closest(".mu-modal").hide();
      $(".mu-modal-overlay").hide();
      return;
    }

    if ($(".mu-modal-overlay").length == 0) {
      $("body").append("<div class='mu-modal-overlay'></div>");
    }

    var title = opts.title;

    $(this).each(function() {
      var $modal = $(JST["templates/mu.modal"]());
      $modal.find("h2").text(title);
      $modal.hide();

      var $element = $(this);
      $modal.append($element);
      $modal.appendTo("body");

      $modal.on("click", ".close", function() {
        $modal.muModal("hide");
      });
    });
  };
})(jQuery);
