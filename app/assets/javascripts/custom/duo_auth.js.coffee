$(($) ->
  make_meta_factory = ->
    console.log("make_meta_factory")
    $D.run($("#root_authority").val(), "make", "CapSuites::DuoAuth", "meta_factory", {}).then (result) ->
      $("#meta_factory_authority").val(result.result.root_authority.url)

  make_factory = ->
    $D.run($("#meta_factory_authority").val(), "make", $("#ikey").val(), $("#skey").val(), $("#host").val()).then (result) ->
      $("#factory_authority").val(result.result.factory_authority.url)

  make_approver = ->
    $D.run($("#factory_authority").val(), "make", $("#username").val(), $("#target_authority").val(), $("#message").val(), $("#args").val()).then (result) ->
      $("#approver_authority").val(result.result.approver_authority.url)

  request_approval = ->
    $D.run($("#approver_authority").val(), "request").then (result) ->
      console.log("sending to Duo": result.result)
      Duo.init(result.result)

      Duo.ready (sig_response) ->
        $D.run($("#approver_authority").val(), "verify", sig_response).then (result) ->
          $("#result").html(js_beautify(JSON.stringify(result.result)))

  $("#make_factory").click ->
    meta_factory_authority = $("#meta_factory_authority").val()
    if !meta_factory_authority
      make_meta_factory().then(make_factory)
    else
      make_factory()

  $("#make_approver").click(make_approver)
  $("#request_approval").click(request_approval)
)
