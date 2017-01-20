(function($) {

  function ApiClient() {
    this.url  = "/api/mobile";
  }

  var prototype = ApiClient.prototype;

  prototype.getPetitionInfo = function(petitionId) {
    return $.get(this.url + "/petitions/" + petitionId)
  };

  window.apiClient = new ApiClient;
})(jQuery);
