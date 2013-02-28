function setFocus() {
    $("#message_body").focus();
}

function update_byte_bar(n) { // for proof graph at the bottom

}

$(document).ready(function () {
    // The link with ID "copy-dynamic" will copy the current value
    // of a dynamically changing input with the ID "dynamic"

    $('body').cryptoSeed({
        'format': 'bytes',
        'length': 25,
        'output': '#randomEntropy',
        'byteValueCallback': update_byte_bar
    });

});