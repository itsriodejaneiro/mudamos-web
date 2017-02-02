(function($) {

  // This is not good, but I would not like to make a request to fetch this HTML
  var template = [
    "<div class='petition-widget-builder'>",
    "  <h2> Incorporar petição </h2>",
    "  <span class='close'>X</span>",
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
    "  <input type='text' class='source-code' />",
    "  <div class='previewer'>",
    "</div>"
  ].join("");

  var buildUrl = function(petitionId) {
    return [
      location.protocol, "//", location.host, "/embedded/petitions/", petitionId
    ].join("");
  }

  $.fn.petitionWidgetBuilder = function(opts) {
    opts = opts || {};

    var petitionId = opts.petitionId;
    var petitionName = opts.petitionName;

    if (!petitionId || !petitionName) {
      throw "petitionId and petitionName is required"
    }

    $(this).each(function() {
      var $element = $(this);

      var $petitionWidgetBuilder = $(template);
      $element.append($petitionWidgetBuilder);

      $element.find("input[type=checkbox]").switch();
      $element.find(".petition-name").text(petitionName);

      var buildIframe = function(hasDescription, hasProgress, hasSigners) {
        if (!$element.find(".previewer iframe").length) {
          $element.find(".previewer").append("iframe");
        }

        $element.find(".previewer iframe")
          .prop("src", buildUrl(petitionId) + "?flags=" + buildFlags(hasDescription, hasProgress, hasSigners)
      };
    });
  };
})(jQuery);
