(function($) {

  function ApiClient() {
    this.url  = "/api/v2";
  }

  var prototype = ApiClient.prototype;

  prototype.getPetitionInfo = function(petitionId) {
    return $.get(this.url + "/petitions/" + petitionId + "/info");
  };


  prototype.getPetitionSigners = function(petitionId, limit) {
    return $.get(this.url + "/petitions/" + petitionId + "/signers", { limit: limit });
  };

  window.apiClient = new ApiClient;
})(jQuery);
