(function($) {

  var buildPlugin = function(petitionId, apiClient, $element, addRow) {
    var refreshList = function() {
      // TODO this is mocked right now
      apiClient.getPetitionSigners(petitionId, "2016-01-01T00:00:00", "2017-01-30T23:59:59")
        .then(function(response) {

          var signers = response.signers;
          for (var i = 0; i < Math.min(signers.length, 4); i++) {
            var signer = signers[i];
            addRow($element, signer);
          }
        });
    };

    refreshList();
  }

  $.fn.petitionSignersTablet = function(petitionId, apiClient) {
    $(this).each(function(idx, element) {
      var $element = $(element);

      $element.append("<div class='signers-tablet'><ul class='list-unstyled list-inline'></ul></div>");

      var addRow =  function($element, userInfo) {
        var $row = $("<li></li>");

        var $img = $("<div class='pull-left'><img /></div>");
        // TODO this is mocked while we don't have the user photos
        $img.find("img").attr("src", "https://robohash.org/" + userInfo.name);
        $row.append($img);

        $element.find("ul").append($row);
      };

      buildPlugin(petitionId, apiClient, $element, addRow);
    });

    return this;
  };

  $.fn.petitionSignersDesktop = function(petitionId, apiClient) {
    $(this).each(function(idx, element) {
      var $element = $(element);

      $element.append("<div class='signers-desktop'><ul class='list-unstyled'></ul></div>");
     
      var addRow = function($element, userInfo) {
        var $row = $("<li></li>");

        var $img = $("<div class='pull-left'><img /></div>");
        // TODO this is mocked while we don't have the user photos
        $img.find("img").attr("src", "https://robohash.org/" + userInfo.name);
        $row.append($img);

        var $name = $("<div class='user-name'><strong/></div>");
        $name.find("strong").text(userInfo.name);
        $row.append($name);

        // TODO this is mocked
        var $signTime = $("<div class='sign-time'><small/></div>");
        $signTime.find("small").text("30 minutos atrás");
        $row.append($signTime);

        $element.find("ul").append($row);
      }

      buildPlugin(petitionId, apiClient, $element, addRow);
    });

    return this;
  }
})(jQuery);
