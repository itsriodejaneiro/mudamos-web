var VIEWPORT_WIDTH = $(window).width();

    if( VIEWPORT_WIDTH > 600 ){
        var ROWS = 1;
        var SLIDES = 3;
    } else if( VIEWPORT_WIDTH < 559 ){
        var ROWS = 1;
        var SLIDES = 1;
    }

$(document).ready(function() {

    $('#btn-quemsomos').hover(
        function(){ 
           $('#btn-assine').toggleClass('active') 
        }
    )

    

});


