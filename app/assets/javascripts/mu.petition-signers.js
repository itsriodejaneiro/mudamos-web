(function($) {

  var buildPlugin = function(petitionId, petitionInProgress, apiClient, $element, addRow, opts) {
    opts = opts || {};
    var size = opts.size || 4;

    var refreshList = function() {
      apiClient.getPetitionSigners(petitionId, size)
        .then(function(response) {

          $element.children().remove();
          var signers = response.signers;
          for (var i = 0; i < Math.min(signers.length, size); i++) {
            var signer = signers[i];
            addRow($element, signer);
          }
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

        var $img = $("<div class='pull-left'><img /></div>");
        $img.find("img").attr("src", userInfo.profile_picture);
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

      $element.append("<div><h3 class='title'>Assinantes recentes</h3><ul class='list-unstyled'></ul></div>");
     
      var addRow = function($element, userInfo) {
        var $row = $("<li></li>");

        var $img = $("<div class='pull-left'><img /></div>");
        $img.find("img").attr("src", userInfo.profile_picture);
        $row.append($img);

        var $name = $("<div class='user-name'><strong/></div>");
        $name.find("strong").text(userInfo.name);
        $row.append($name);

        var $signTimeAndLocation = $("<div class='sign-time-and-location'><small/></div>");
        $signTimeAndLocation.find("small").text(
          jQuery.timeago(new Date(userInfo.date)) + " | " +
          userInfo.city + " - " + userInfo.uf
        );
        $row.append($signTimeAndLocation);

        $element.append($row);
      }

      buildPlugin(petitionId, petitionInProgress, apiClient, $element.find("ul"), addRow, opts);
    });

    return this;
  }
})(jQuery);
