function randomString(length) {
    var chars = '0123456789ABCDEFGHIJKLMNOPQRSTUVWXTZabcdefghiklmnopqrstuvwxyz'.split('');
    var randoms = $('#randomEntropy').val();
    var randomsarr = randoms.split(",");    
    var str = '';
    for (var i = 0; i < 25; i++) {
        str += chars[randomsarr[i]];
    }
    return str;
}

function EncodeThis() {
  password = randomString(12);
  $("#message_body").val(GibberishAES.enc($("#message_body").val(), "#" + password));
}

function DecodeThis() {
  $("#message_body").val(GibberishAES.dec($("#message_body").val(), window.location.hash));
}