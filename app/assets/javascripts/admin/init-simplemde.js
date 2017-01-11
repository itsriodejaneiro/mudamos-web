(function($) {
  $(document).ready(function() {
    $('.markdown-input').each(function() {
      new SimpleMDE({
        element: this,
        parsingConfig: {
          strikethrough: false
        },
        toolbar: ["bold", "italic", "heading", "|", "quote", "unordered-list", "ordered-list", "|", "guide"]
      });
    });
  });
})(jQuery);
