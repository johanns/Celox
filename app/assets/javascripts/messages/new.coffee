$('.messages.new').ready ->
  sjcl.random.startCollectors()

  resetState = ->
    $('#message_body').empty()
    $('#data').empty()

  updateCounter = ->
    c = 2000 - $('#message_main').val().length
    if c <= 0
      $('#char_count').text(c)
      $('#encrypt').prop('disabled', true)
    else
      $('#char_count').text(c)
      if $('#encrypt').prop('disabled')
        $('#encrypt').prop('disabled', false)

  $(document).on 'page:load', ->
    resetState()

  $('#new_message').on 'ajax:before', (e) ->
    $('#encrypt').prop('disabled', true).text('Working...')
    $('#message_main').prop('readOnly', true)

    password = generatePassword(8)

    e = sjcl.encrypt(password, $('#message_main').val(), {
      count: 2000
      salt: sjcl.random.randomWords(32)
      adata: sjcl.random.randomWords(32)
      ks: 256
      mode: "gcm"
    })

    $('#message_body').val(e)
    $('#clientJson').html(syntaxHighlight(JSON.parse(e)))
    $('#data').append(password)
  .on 'ajax:success', (e, data, status, xhr) ->
    $('#form').addClass('animated zoomOut')
    .one 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend', ->
      $('#form').hide()
      $("#result").addClass('animated zoomIn').show()
  .on 'ajax:error', (e, status, error) ->
    UIkit.notify {
      message: 'Failed to store your message; try again...'
      timeout: 0
      status: 'danger'
      pos: 'top-center'
    }

    resetState()

  $('#message_main').on 'keyup', ->
    updateCounter()
  .on 'change', ->
    updateCounter()
