var notify = {}
  var comentUsers =[
      {
        name: "Victor",
        msg: "respondeu seu comentário",
        time: "há 5 horas",
        foto: "",
        status: "unseen"
      },
      {
        name: "Dudu",
        msg: "adicionou um comentário a discussão",
        time: "há 20 horas",
        foto: "",
        status: "seen"
      },
      {
        name: "Felipe Amorim",
        msg: "deu like no seu comentário",
        time: "há 1 hora",
        foto: "",
        status: "unseen"
      },
      {
        name: "Dan",
        msg: "deu dislike no seu comentário",
        time: "há 8 horas",
        foto: "",
        status: "unseen"
      }
    ];


  notify.user ={
    element: '.notification-message',

    notificationNumber: function(){
      var num = $(comentUsers).length;
        console.log(num);
      if (num < 9){
        $(this.element).text(num);
      } else {
        $(this.element).text('9+');
      }

      $.each(comentUsers, function(index, val){
          //console.log( index + ": " + val.name );
        $('.notification-dropdown').append('\n\
          <li class="notification-dropdown-item '+ val.status+'">\n\
            <a>\n\
              <div class="notification-media">\n\
                <img src='+ val.foto +' alt="User Profile">\n\
              </div>\n\
              <div class="notification-content">\n\
                <p><b>'+ val.name +' </b>'+ val.msg +'</p>\n\
                <span>'+ val.time +' </span>\n\
              </div>\n\
            </a>\n\
          </li>\n\
        ');
      })
    },

    showNotification: function(){
      $('html').click(function(event) {
        if (event.target.className == 'notification-message' || event.target.className == 'notification-icon' || event.target.className == 'icon-notifications'){
          $('.notification-dropdown').addClass('open');
        } else{
          $('.notification-dropdown').removeClass('open');
        }
      });
    },
    init: function(){
      // this.notificationNumber();
      this.showNotification();
      //console.log('Notify User initialized: ' + comentUsers[0].name);
    }
  }

  notify.init = function(){
    notify.user.init();
  };