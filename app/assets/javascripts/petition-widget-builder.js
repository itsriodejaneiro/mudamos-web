(function($) {

  var template = JST["templates/petition-widget-builder"]();

  var buildUrl = function(petitionId) {
    return [
      location.protocol, "//", location.host, "/embedded/petitions/", petitionId
    ].join("");
  };

  var buildFlags = function(hasDescription, hasProgress, hasSigners) {
    var flags = [];

    if (hasDescription) flags.push("has_description");
    if (hasProgress) flags.push("has_progress");
    if (hasSigners) flags.push("has_signers");

    return flags.join(" ");
  };

  $.fn.petitionWidgetBuilder = function(opts) {
    opts = opts || {};

    if (opts == "show") {
      $(this).show();
      $(".petition-widget-builder-overlay").show();
      return;
    } else if (opts == "hide") {
      $(this).hide();
      $(".petition-widget-builder-overlay").hide();
      return;
    }

    var petitionId = opts.petitionId;
    var petitionName = opts.petitionName;
    var cycleColor = opts.cycleColor;

    if (!petitionId || !petitionName) {
      throw "petitionId and petitionName are required"
    }

    if ($(".petition-widget-builder-overlay").length == 0) {
      $("body").append("<div class='petition-widget-builder-overlay'></div>");
    }

    $(this).each(function() {
      var $element = $(this);
      $element.hide();

      var $petitionWidgetBuilder = $(template);
      $element.append($petitionWidgetBuilder);

      $element.find(".close").click(function() {
        $element.petitionWidgetBuilder("hide");
      });

      $element.on("open", function() {
        $element.show();
      });

      $element.find("input[type=checkbox]").muSwitch();
      $element.find(".petition-name").text(petitionName);
      $element.find(".separator span").css("background-color", cycleColor);

      var buildIframe = function() {
        var hasDescription = $element.find(".show-description").is(":checked");
        var hasProgress = $element.find(".show-progress").is(":checked");
        var hasSigners = $element.find(".show-signers").is(":checked");

        if (!$element.find(".previewer iframe").length) {
          $element.find(".previewer").append("<iframe/>");
          $element.find(".previewer iframe").load(function() {
            var $me = $(this);
            $me.css("height", this.contentWindow.document.body.offsetHeight + "px");
            $element.find(".source-code").val($me.prop("outerHTML"));
          });
        }

        $element.find(".previewer iframe")
          .css("width", "322px")
          .css("border", "none")
          .css("overflow", "hidden")
          .prop("scrolling", "no")
          .prop("frameborder", "0")
          .prop("allowTransparency", "true")
          .prop("src", buildUrl(petitionId) + "?flags=" + buildFlags(hasDescription, hasProgress, hasSigners))

      };

      buildIframe();
      $element.find("input[type=checkbox]").change(buildIframe);
    });
  };
})(jQuery);
