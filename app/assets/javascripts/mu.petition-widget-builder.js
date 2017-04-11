(function($) {

  var template = JST["templates/mu.petition-widget-builder"]();

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

  $.fn.muPetitionWidgetBuilder = function(opts) {
    opts = opts || {};

    var petitionId = opts.petitionId;
    var petitionName = opts.petitionName;
    var cycleColor = opts.cycleColor;

    if (!petitionId || !petitionName) {
      throw "petitionId and petitionName are required"
    }

    $(this).each(function() {
      var $element = $(this);
      $element.muModal({
        title: "Faça Parte"
      });

      var $petitionWidgetBuilder = $(template);
      $element.append($petitionWidgetBuilder);

      $element.find("input[type=checkbox]").muSwitch();
      $element.find(".petition-name").text(petitionName);
      $element.closest(".mu-modal").find(".separator span").css("background-color", cycleColor);

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
