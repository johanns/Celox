@syntaxHighlight = (json) ->
  json = JSON.stringify(json, `undefined`, 2)  unless typeof json is "string"
  json = json.replace(/&/g, "&amp;").replace(/</g, "&lt;").replace(/>/g, "&gt;")

  json.replace /("(\\u[a-zA-Z0-9]{4}|\\[^u]|[^\\"])*"(\s*:)?|\b(true|false|null)\b|-?\d+(?:\.\d*)?(?:[eE][+\-]?\d+)?)/g, (match) ->
    cls = "number"

    if /^"/.test(match)
      if /:$/.test(match)
        cls = "key"
      else
        cls = "string"
    else if /true|false/.test(match)
      cls = "boolean"
    else cls = "null" if /null/.test(match)

    "<span class=\"" + cls + "\">" + match + "</span>"

@generatePassword = (len) ->
  charSet = "abcdefghijklnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789-"

  n = charSet.length
  password = ""

  for i in [1..len]
    password += charSet.charAt(Math.floor(Math.random() * n))

  password