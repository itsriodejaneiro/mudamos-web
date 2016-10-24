var admin = {};

admin.dashboard = {
  hide: function (){
    $('#dashboard-signup-month').css({'display':'none'});
    $('#dashboard-comment-day').css({'display':'none'});
  },
  filter: function(){
    $('input[name="daterange"]')
      .datepicker({
      language: 'pt-BR',
      orientation: 'auto bottom',
      format: 'yyyy-mm-dd',
      todayHighlight: false,
      startDate: '-2y',
      endDate: '0d',
      multidate: true
    })
      .on('changeDate', function(ev){
        var currDate = $('input[name="daterange"]').val().split(',');

        if (currDate.length > 1) {
          document.start_loading();

          var url = window.location.href;
          url = url.split('?')[0];
          url += '?start_date=' + currDate[0];
          url += '&end_date=' + currDate[1];

          window.location.href = url;
        }
      });

    $('.icon-calendar').click(function() {
      $('input[name="daterange"]').datepicker('show');
    });

    $('.filters span').click(function(event){
      $(this).siblings('span').removeClass('active');
      $(this).addClass('active');
      var type = $(this).data("range");

      $('.type').text(' ' + type);

      if (type == "dia"){
        $('[id*="-month"]').fadeOut('fast', function(){
          $('[id*="-day"]').fadeIn('fast');
        });

      } else {
        $('[id*="-day"]').fadeOut('fast', function(){
          $('[id*="-month"]').fadeIn('fast');
        });
      }
    });
    $('#cycle-list-filters .filter-item').click(function(){
      var order_by = $(this).data('filter');
      window.location.href = '?order=' + order_by;
    });
  },

  init: function(){
    this.hide();
    this.filter();
  }
},
admin.edit ={
  mce: function(querySelector){
    tinyMCE.init({
      selector: querySelector,
      plugins: ["autolink lists link image preview anchor paste", "fullscreen hr code visualblocks visualchars", "table paste"],
      toolbar: "undo redo | styleselect | bold italic | alignleft aligncenter alignright alignjustify | bullist numlist outdent indent | link image",
      content_css: "#{ActionController::Base.helpers.asset_path('tinymce.css')}",
    });
  },

  click: function(){
    $('.icon-edit').click(function(){
      var mce_el = $(this).siblings('.editable-content').attr('id');
      tinymce.get(mce_el).show(); 
      $(this).siblings('.pull-right').children('a.btn').removeClass('hidden');
    });

    $('.mce-button').click(function(){
      var mce_el = $(this).parent().siblings('.editable-content').attr('id');
      tinymce.get(mce_el).hide(); 
      $(this).addClass('hidden');
    });
  },

  init: function(querySelector){
    this.mce(querySelector);
    this.click();
  }
},
admin.helpers = {
  equalHeight: function(elements){
    var max_height = 0

    $(elements).each(function(){
      max_height = Math.max(max_height, $(this).height());
    });
    // Set All QueryElements to highest value!
    $(elements).height(max_height);
  },
  truncate: function(trunc){
    $(trunc).dotdotdot({
      after: "a.read-more",
      height: parseInt( $(trunc).css('line-height'), 10) * 3,
      lastCharacter: {
          remove: [ ' ', ',', ';', '.', '!', '?' ],
          noEllipsis: []
      }
    });

    $('a.read-more').on( 'click', function(event) {
     event.preventDefault();
     $(this).siblings(trunc).trigger("destroy");
     $(this).hide();
     $(this).parent().find('a.read-less').show();
    });

    $('a.read-less').on( 'click', function(event) {
     event.preventDefault();
     $(this).hide();
     $(this).siblings(trunc).dotdotdot({
        height: parseInt( $('.comments-dotdotdot').css('line-height'), 10) * 3,
        lastCharacter: {
            remove: [ ' ', ',', ';', '.', '!', '?' ],
            noEllipsis: []
        }
      });
      $(this).parent().parent().find('a.read-more').show();
    });
  },

  init: function(elements, trunc){
    this.equalHeight(elements);
    this.truncate(trunc);
  },
},
admin.init = function(){
  admin.dashboard.init();
  admin.edit.init();
}
