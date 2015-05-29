$(".messages.new").ready ->
  sjcl.random.startCollectors()

  $("#message_body").val("")

  encryptMessage = ->
    password = generatePassword(8)

    e = sjcl.encrypt(password, $("#message_body").val(), {
      count: 2000,
      salt: sjcl.random.randomWords(32),
      adata: sjcl.random.randomWords(32),
      ks: 256,
      mode: "gcm"
    })

    $("#message_body").val(e)
    $("#clientJson").html(syntaxHighlight(JSON.parse(e)))
    $("#data").append(password)

  $("#encrypt").on "click", ->
    $('#inputs').addClass 'animated fadeOutDown'
    encryptMessage()

  updateCounter = ->
    c = 2000 - $("#message_body").val().length
    if c <= 0
      $("#char_count").text c
      $("#encrypt").prop 'disabled', true
    else
      $("#char_count").text c
      if $("#encrypt").prop 'disabled'
        $("#encrypt").prop 'disabled', false

  $("#message_body").on "keyup", ->
    updateCounter()
