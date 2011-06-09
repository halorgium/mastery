$(($) ->
  n = 1
  replaceAuthorityUrl = (url) ->
    url = url.replace(/^"/, "")
    url = url.replace(/"$/, "")
    current = n
    n += 1
    $D.read(url).then (result) ->
      console.log(result)
      label = "[#{result.class}]"
      anchor = authorityAnchor(label, url)
      console.log("saving #{url} to history")
      $(anchor).appendTo($("#history .first")).wrap("<div>Authority ##{current}: </div>")
      html = $("#result").html()
      $("#result").html(html.replace("[Authority ##{current}]", anchor))
    "[Authority ##{current}]"

  authorityAnchor = (label, authority) ->
    "<a class=\"authority\" data-authority=\"#{authority}\" href=\"#\">#{label}</a>"

  display = (result) ->
    console.log(result)
    source = js_beautify(JSON.stringify(result))
    source = source.replace(/"(http:\/\/[^"]*)"/g, replaceAuthorityUrl)
    $("#result").html(source)

  $("#read").click ->
    console.log("read clicked")
    $D.read($("#authority").val()).always(display).always (result) ->
      $("#class-name").html(result.class)

  $("#execute").click ->
    console.log("execute clicked")
    args = JSON.parse($("#args").val())
    $D.run($("#authority").val(), $("#message").val(), args...).always(display)

  $(".authority").live 'click', ->
    authority = $(this).data("authority")
    console.log("switching to authority: #{authority}")
    $("#authority").val(authority)
    $("#read").triggerHandler('click')
)
