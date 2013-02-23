function setFocus() {
  $("#message_body").focus();
}

    function update_byte_bar(n) { // for proof graph at the bottom

    }

$(document).ready(function() {

    $('a#copy-description').zclip({
        path:'js/ZeroClipboard.swf',
        copy:$('p#description').text()
    });

    // The link with ID "copy-description" will copy
    // the text of the paragraph with ID "description"


    $('a#copy-dynamic').zclip({
        path:'js/ZeroClipboard.swf',
        copy:function(){return $('input#dynamic').val();}
    });

    // The link with ID "copy-dynamic" will copy the current value
    // of a dynamically changing input with the ID "dynamic"

    $('body').cryptoSeed({ 
            'format': 'bytes',
            'length': 25,
            'output': '#randomEntropy',
            'byteValueCallback': update_byte_bar
    });

});