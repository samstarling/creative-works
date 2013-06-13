$(document).ready(function() {
  fetchData();
});

function fetchData() {
  var cws;
  
  $.ajax({
    url: '/data',
    async: false,
    dataType: 'json',
    success: function (json) {
      cws = json;
    }
  });
  
  var count = 0;
  var timer = setInterval(function(){
    $(".text .title").text(cws[count]["title"]);
    $(".text .description").text(cws[count]["description"]);
    if(cws[count]["thumbnail"]) {
      $(".img img").attr('src', cws[count]["thumbnail"]["@id"]);
    }
    count++
    if (count === cws.length) {
      clearInterval(timer);
      fetchData();
    }
  }, 5000);
}
