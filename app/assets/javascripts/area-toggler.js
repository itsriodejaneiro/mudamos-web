(function($) {
  "use strict";

  $(document).ready(function() {
    // Hide / show area containers
    $("body").on("click", ".area-toggler", function(e) {
      e.preventDefault();

      var $toggler = $(this);
      var openClass = "area-open";
      var containerSelector = $toggler.data("container");

      function showContainer() {
        $(containerSelector).slideDown();
      }

      function hideContainer() {
        $(containerSelector).slideUp();
      }

      if ($toggler.hasClass(openClass)) {
        $toggler.removeClass(openClass);
        hideContainer();
      } else {
        $toggler.addClass(openClass);
        showContainer();
      }
    });
  });

})(jQuery);
