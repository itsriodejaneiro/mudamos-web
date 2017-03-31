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

  function blockScrollTo() {
    $(".block-scroll-to").each(function() {
      var $link = $(this);
      var $block = $link.closest("section");

      // Removes link if there is not next section
      if ($block.nextAll("section:visible").length == 0) {
        $link.remove();
      }
    }).on("click", function(e) {
      e.preventDefault();

      var $nextBlock = $(this).closest("section").nextAll("section:visible").get(0);
      var $navBar = $(".base-navbar");
      var headerHeight = $navBar.hasClass("stuck") ? -$navBar.height() : 20;

      $.scrollTo($nextBlock, 1000, { offset: headerHeight });
    });
  }

  $(document).ready(function() {
    homeTools();
    blockScrollTo();
  });
})(jQuery);
