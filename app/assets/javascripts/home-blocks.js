(function($) {
  "use strict";

  function homeTools() {
    var $section = $(".home-block-tools.carousel");

    function hideAll() {
      $section.find(".display .tool, .display .block-body").hide();
    }

    function toggleTool() {
      var $tool = $(this);
      var index = $tool.parent().children().index($tool);

      hideAll();

      $($section.find(".display .tool")[index]).show();
      $($section.find(".display .block-body")[index]).show();
    }

    hideAll();
    $section.on("mouseover", ".options .tool", toggleTool);

    // Init first tool
    $section.find(".options .tool:first").trigger("mouseover");
  }

  $(document).ready(function() {
    homeTools();
  });
})(jQuery);
