$(document).ready(function() {
  fetchData();
  setInterval(clearData, 8500);
});

function clearData() {
  $($(".tweet span").get().reverse()).each(function(i) { 
    $(this).delay(13 * i).fadeOut(750, function() { 
      $(this).remove();
      if($(".tweet span").length == 0) {
        fetchData();
      }
    });
  });
}

function fetchData() {
  $.getJSON('/data', function(data) {
    fadeInData(data.d);
  });
}

function fadeInData(data) {
  $('.tweet').fadeOut(1).delay(1000).html("").fadeIn(1, function() {
    var spans = '<span>' + data.split(' ').join('</span> <span>') + '</span>';
    $(spans).hide().appendTo('.tweet').each(function(i) {
      $(this).delay(10 * i).fadeIn(350);
    });
  });
  
}
