(function($) {

  // This is not good, but I would not like to make a request to fetch this HTML
  var template = [
    "<div class='petition-widget-builder'>",
    "  <h2> Incorporar petição </h2>",
    "  <i class='close icon-close'></i>",
    "  <div class='separator'><span></span></div>",
    "  <p> Incorpore a petição \"<span class='petition-name'></span>\" em seu site </p>",
    "  <h3> Personalizar </h3>",
    "  <ul class='list-unstyled'>",
    "    <li>",
    "      <input type='checkbox' class='show-description' checked='checked' /><label> Exibir descrição </label>",
    "    </li>",
    "    <li>",
    "      <input type='checkbox' class='show-progress' checked='checked' /><label> Exibir detalhes do progresso da votação </label>",
    "    </li>",
    "    <li>",
    "      <input type='checkbox' class='show-signers' checked='checked' /><label> Exibir assinantes </label>",
    "    </li>",
    "  </ul>", 
    "  <h3> Código </h3>",
    "  <input type='text' class='source-code' readonly='readonly' />",
    "  <div class='previewer'>",
    "</div>"
  ].join("");

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

    var petitionId = opts.petitionId;
    var petitionName = opts.petitionName;
    var cycleColor = opts.cycleColor;

    if (!petitionId || !petitionName) {
      throw "petitionId and petitionName is required"
    }

    $(this).each(function() {
      var $element = $(this);
      $element.hide();

      var $petitionWidgetBuilder = $(template);
      $element.append($petitionWidgetBuilder);

      $element.find(".close").click(function() {
        $element.hide();
      });

      $element.on("open", function() {
        $element.show();
      });

      $element.find("input[type=checkbox]").switch();
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
