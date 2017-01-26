(function($) {
  $.fn.progressBar = function(opts) {
    opts = opts || {}
    var color = opts.color || "#000";
    var backgroundColor = opts.backgroundColor || "#FFF";
    var currentPercentage = opts.percentage || 0;

    var $container = $(this);
    $container.addClass("progress-bar");

    var $bar = $("<div></div>");
    $bar.addClass("progress-bar-container");
    $bar.css("background-color", backgroundColor);

    $container.append($bar);

    var $currentPercentageBar = $("<div></div>");
    $currentPercentageBar.addClass("progress-bar-filling");
    $currentPercentageBar.css("background-color", color);
    $currentPercentageBar.css("width", currentPercentage);

    $container.append($currentPercentageBar);

    var $marker = $("<div><span></span><span></span><span></span></div>");
    $marker.addClass("progress-bar-marker");
    $marker.css("left", currentPercentage);
    $marker.children("span").css("background-color", color);

    $container.append($marker);

    return {
      update: function(percentage) {
        $currentPercentageBar.css("width", percentage);
        $marker.css("left", percentage);
      }
    }
  }
})(jQuery);
