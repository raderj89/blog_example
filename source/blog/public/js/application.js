$(document).ready(function() {
  $('.godzilla').on('click', function(e){
    e.preventDefault();
    $.ajax({
      url: '/posts/godzillaed',
      type: 'GET',
      dataType: 'json'
    }).done(function(data) {
      $('.posts').empty();
      $.each(data, function(index, post){
        $('.posts').append('<h2><a href="/posts/' + post.id + '">'+ post.title + '</a></h2>');
      })
    })
  })
});
