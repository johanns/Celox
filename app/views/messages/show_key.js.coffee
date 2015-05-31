$ ->
  $('#serverJson').html syntaxHighlight(<%= @message.body.html_safe %>)

  k = window.location.href.concat("<%= @message.key.html_safe %>/#")
  $('#data').prepend k

  $('#form').one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
    $('#form').hide()
    $("#result").addClass('animated fadeInDown').show()