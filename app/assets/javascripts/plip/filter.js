(function($, document) {
  $(document).ready(function() {
    $("#btn-quemsomos").hover(function() {
      $("#btn-assine").toggleClass("active-btn");
    });

    $("#btn-envie").hover(function() {
      $("#btn-assine").toggleClass("active-btn");
    });

    $(".carousel").carousel({
      interval: false
    });
  });
})(jQuery, document);
