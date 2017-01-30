(function($) {

  function ApiClient() {
    this.url  = "/api/v2";
  }

  var prototype = ApiClient.prototype;

  prototype.getPetitionInfo = function(petitionId) {
    return $.get(this.url + "/petitions/" + petitionId + "/info");
  };


  prototype.getPetitionSigners = function(petitionId, start, end) {
    return $.get(this.url + "/petitions/" + petitionId + "/signers", { from: start, to: end });
  };

  window.apiClient = new ApiClient;
})(jQuery);
