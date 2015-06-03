$('#serverJson').html(syntaxHighlight(<%= @message.body.html_safe %>))

k = window.location.href.concat("<%= @message.key.html_safe %>/#")
$('#data').prepend(k)