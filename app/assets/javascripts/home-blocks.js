(function($) {
  "use strict";

  function homeTools() {
    var $section = $(".home-block-tools.carousel");

    function hideAll() {
      $section.find(".display .tool, .display .block-body").hide();
    }

    function toggleTool() {
      var $tool = $(this);
      var activeIndex = $tool.parent().children().index($tool);

      hideAll();

      $($section.find(".display .tool")[activeIndex]).show();
      $($section.find(".display .block-body")[activeIndex]).show();

      $section.find(".options .tool").each(function(index, tool) {
        if (index == activeIndex) {
          $(tool).addClass("active");
        } else {
          $(tool).removeClass("active");
        }
      });
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
