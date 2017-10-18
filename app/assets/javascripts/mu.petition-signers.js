(function($) {

  function capitalizeFirstLetter(string) {
    return string.charAt(0).toUpperCase() + string.slice(1);
  }

  var buildPlugin = function(petitionId, petitionInProgress, apiClient, $element, addRow, opts) {
    opts = opts || {};
    var size = opts.size || 5;

    var refreshList = function() {
      apiClient.getPetitionSigners(petitionId, size)
        .then(function(response) {

          $element.children().remove();
          var signers = response.signers || [];

          if (signers.length > 0) {
            $element.parent().removeClass("hidden");
          } else {
            $element.parent().addClass("hidden");
          }

          for (var i = 0; i < Math.min(signers.length, size); i++) {
            var signer = signers[i];
            addRow($element, signer);
          }
        })
        .fail(function() {
          $element.parent().addClass("hidden");
        });
    };

    refreshList();
    if (petitionInProgress) setInterval(refreshList, 10000)
  }

  $.fn.muPetitionSignersSmall = function(petitionId, petitionInProgress, apiClient, opts) {
    $(this).each(function(idx, element) {
      var $element = $(element);

      $element.append("<div><ul class='list-unstyled list-inline'></ul></div>");

      var addRow =  function($element, userInfo) {
        var $row = $("<li></li>");

        var $img = $("<div class='pull-left avatar'></div>");
        $img.css("background-image", "url('" + userInfo.profile_picture + "')");
        $row.append($img);

        $element.append($row);
      };

      buildPlugin(petitionId, petitionInProgress, apiClient, $element.find("ul"), addRow, opts);
    });

    return this;
  };

  $.fn.muPetitionSigners = function(petitionId, petitionInProgress, apiClient, opts) {
    $(this).each(function(idx, element) {
      var $element = $(element);

      $element.append("<div class='container-fluid'><h3 class='title'>Assinantes recentes</h3><ul class='list-unstyled'></ul></div>");

      var addRow = function($element, userInfo) {
        var $row = $("<li></li>");

        var $img = $("<div class='pull-left avatar'></div>");
        $img.css("background-image", "url('" + userInfo.profile_picture + "')");
        $row.append($img);

        var $name = $("<div class='user-name'></div>");
        $name.text(userInfo.name);
        $row.append($name);

        var $signTimeAndLocation = $("<div class='sign-time-and-location'></div>");
        var userLocation = userInfo.city && userInfo.uf ? userInfo.city + " - " + userInfo.uf : null;
        var signTimeText = capitalizeFirstLetter(jQuery.timeago(new Date(userInfo.date)));

        if (userLocation) signTimeText += " | " + userLocation;

        $signTimeAndLocation.text(signTimeText);
        $row.append($signTimeAndLocation);

        $element.append($row);
      }

      buildPlugin(petitionId, petitionInProgress, apiClient, $element.find("ul"), addRow, opts);
    });

    return this;
  }
})(jQuery);
