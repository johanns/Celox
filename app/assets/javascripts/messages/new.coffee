class MessageNew
    constructor: ->
        console.log("cstr: MessageNew...")

        @form = $('#messageForm')
        @body = $('#messageBody')
        @counter = $('#messageBodyCounter')
        @submit = $('#messageSubmit')
        @result = $('#messageResult')
        @uri = $('#messageURI')

        @spinnerModal = UIkit.modal($('#spinnerModal'))[0]

        @data = null
        @key = null

        @reset()

        @handleCounter()
        @handleFormSubmission()

    handleCounter: =>
        @body.on 'keyup change', => @updateCounter()

    updateCounter: =>
        c = 2000 - @body.val().length
        if c <= 0 || @body.val().length <= 0
            @counter.text(c)
            @submit.prop('disabled', true)
        else
            @counter.text(c)
            if @submit.prop('disabled')
                @submit.prop('disabled', false)

    handleFormSubmission: =>
        # Show spinner
        @form.on 'ajax:before', (event) =>
            @submit.prop('disabled', true)
            @spinnerModal.show()
            @data = @body.val()

            try
                @key = @generateKey(8)

                e = sjcl.encrypt(@key, @data, {
                    count: 2000
                    salt: sjcl.random.randomWords(32)
                    adata: sjcl.random.randomWords(32)
                    ks: 256
                    mode: 'gcm' })

                @body.val(e)

                $('#clientJson').html(JSON.parse(e))
            catch error
                UIkit.notification("Failed to encrypt data", { status: 'danger' })
                @reset()
                return false

        # Hide spinner
        @form.on 'ajax:complete', (event, xhr, status) =>
            # Reduce jarring screen transition
            setTimeout =>
                @spinnerModal.hide()
            , 1200
            console.log('complete')

        # Show result URL
        @form.on 'ajax:success', (event, data, status, xhr) =>
            @form.fadeOut 900, =>
                @result.fadeIn(500)
            @uri.val("#{document.location.href}#{data.data}/##{@key}")
            UIkit.notification("Message securly stored", { status: 'success' })

        # Show error message
        @form.on 'ajax:error', (event, xhr, status, error) =>
            @body.val(@data)
            UIkit.notification("Failed to store data on server; try again later", { status: 'danger' })

    reset: =>
        @key = null
        @data = null
        @body.val('')
        @body.prop('disabled', false)
        @counter.text('2000')
        @submit.prop('disabled', true)
        setTimeout =>
            @spinnerModal.hide()
        , 200

    generateKey: (len) ->
      charSet = "abcdefghijklnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789- "

      n = charSet.length
      password = ""

      for i in [1..len]
        password += charSet.charAt(Math.floor(Math.random() * n))

      password

$(document).on 'turbolinks:load', =>
    if $('body').hasClass('messages') && $('body').hasClass('new')
        new MessageNew()
