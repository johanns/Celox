$('.messages.show').ready ->
  p = window.location.hash.substring(1)

  r = JSON.parse($('#data').html())
  if r.read == true
    $('#data').html(r.message)
    $('#block').addClass('uk-block-secondary')
  else
    d = sjcl.decrypt(p, $('#data').html())
    $('#data').html(d)
    $('#block').addClass('uk-block-primary')