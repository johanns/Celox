class MessageShow
    constructor: ->
        console.log('cstr: MessageShow...')

        @body = $('#messageData')

        @decrypt()

    decrypt: =>
        r = JSON.parse(@body.val())
        if !r.read
            k = window.location.hash.substring(1)

            try
                d = sjcl.decrypt(k, r.message)
            catch error
                d = 'Failed to decrypt message. All is lost... I\'m sorry. :('

            @body.val(d)
        else
            @body.val("This was has already been read.\n\nTimestamp: #{r.read}")

$(document).on 'turbolinks:load', =>
    if $('body').hasClass('messages') && $('body').hasClass('show')
        new MessageShow()
