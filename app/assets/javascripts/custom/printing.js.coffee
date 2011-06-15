$(($) ->
  $("#create_data_factory").click ->
    $D.run($("#root_authority").val(), "make", "CapSuites::Data", "factory", {}).then (result) ->
      $("#data_factory_authority").val(result.result.root_authority.url)

  $("#store_data").click ->
    data = $("#data").val()
    $D.run($("#data_factory_authority").val(), "make", {"data": data}).then (result) ->
      $("#full_data_authority").val(result.result.slot_authority.url)
      $("#write_data_authority").val(result.result.write_authority.url)
      read_authority = result.result.read_authority.url
      $("#read_data_authority").val(read_authority)
      $("#target_authority").val(read_authority)

  $("#create_revoke_factory").click ->
    $D.run($("#root_authority").val(), "make", "CapSuites::Revoke", "factory", {}).then (result) ->
      $("#revoke_factory_authority").val(result.result.root_authority.url)

  $("#create_revoke").click ->
    $D.run($("#revoke_factory_authority").val(), "make", $("#target_authority").val()).then (result) ->
      proxy_authority = result.result.proxy_authority.url
      $("#proxy_authority").val(proxy_authority)
      $("#employee_authority").val(proxy_authority)
      revoker_authority = result.result.revoker_authority.url
      $("#revoker_authority").val(revoker_authority)
      $("#revoker_authority2").val(revoker_authority)

  $("#run_revoke").click ->
    $D.run($("#revoker_authority2").val(), "revoke").then (result) ->
      $("#revoke_result").html(js_beautify(JSON.stringify(result.result)))

  $("#run_authority").click ->
    callback = (result) ->
      $("#employee_result").html(js_beautify(JSON.stringify(result.result)))
    errback = (error) ->
      $("#employee_result").html(js_beautify({"error": JSON.stringify(result)}))
    $D.run($("#employee_authority").val(), "read").done(callback).fail(errback)
)
