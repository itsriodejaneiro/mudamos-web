var notify = {}

  notify.user ={

    showNotification: function(){
      $('html').click(function(event) {
        if (event.target.className == 'notification-message' || event.target.className == 'notification-icon' || event.target.className == 'icon-notifications'){
          $('.notification-dropdown').addClass('open');
        } else{
          $('.notification-dropdown').removeClass('open');
        }
      });
    },
    see: function(){
      $('.notification-dropdown-item').click(function(event){
        // event.preventDefault();

        // Marca o item como Visualizado:
        $(this).addClass('seen');

        $.ajax({
          type: 'POST',
          dataType: 'html',
          data: {},
          complete: function() {},
          error: function(jqXHR, textStatus, errorThrown) {
            //
            return alert('Ocorreu algum erro.');
          },
          success: function(data, textStatus, jqXHR) {
            //
          }
        });
      });
    },
    init: function(){
      this.showNotification();
      // this.see();
    }
  },

  notify.comments={
    getComments: function(){
      var str =  window.location.href;

      if (str.includes('?') && str.includes('comments=')) {
        var hash = str.split('comments=')[1];
        hash = hash.split('&')[0];

        var comments_ids = hash.split(',');
        var comments_count = comments_ids.length;

        comment = $("#" + comments_ids[0]);
        // comment.find('.load-more-comments').click()

        if (comments_count > 1) {
          comment.find('.load-more-comments').click()
        } else {
          $('html, body').animate({
            scrollTop: comment.offset().top - 120
          }, 300, function() {
            // Do something fun if you want!
          });
        };
      }
    },
    filterComments: function(){
      var str = window.location.href,
          filter = ''; 
          str = str.split('?')[0];

      $('.comment-filter ul li a').click(function(event){
        filter = $(this).data('filter');
        window.location.href = str + '?comment-filter=' + filter;
      });

      
    },

    init: function(){
      this.getComments();
      this.filterComments();
    }
  }

  notify.init = function(){
    notify.user.init();
  };
