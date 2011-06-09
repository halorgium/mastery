"use strict"

window.$D = window.Drool = {}

(($, $D) ->
  $D.read = (url) ->
    $.ajax(url: url, type: "GET")

  $D.readMe = () ->
    $D.read(window.location)

  $D.run = (url, message, args...) ->
    $.ajax(
      url: url,
      type: "PUT",
      contentType: "application/json",
      data: JSON.stringify({"message": message, "args": args})
    )

  $D.runMe = (message, args...) ->
    $D.run(window.location, message, args...)

  null
)(window.jQuery, window.Drool)

window.DroolClient = class DroolClient
  constructor: (@host, @port) ->
    @clock = 0
    @promises = {}

  connect: (callback) ->
    self = this

    @socket = new io.Socket(@host, port: @port)
    @socket.connect()
    @socket.on 'connect', () ->
      console.log("connected")
      self.send("getHandle").then (handle_result) ->
        revoke_factory_cap = "http://localhost:3000/vats/8MDsmOTvldzkWcPNrtHgc3OSvAT/caps/R7NLBEUX90JzPI7ouRMrA0ZvVmV"
        $D.run(revoke_factory_cap, "make", handle_result).then (the_result) ->
          {proxy_cap, revoker_cap} = the_result.result
          callback(proxy_cap, revoker_cap)

    @socket.on 'message', (data) ->
      message = JSON.parse(data)
      console.log("message: #{JSON.stringify(message)}")

      if message.request
        {q, args} = message.request

        console.log("WHAT???")
        switch q
          when "notify"
            console.log("You just got a message: #{q} -> #{JSON.stringify(args)}")
            $D.run(args[0].data_cap, "get").then (data_result) ->
              $("#hax pre").html(data_result.result)
            #$("#hax pre").html(JSON.stringify(args))
          when "alert"
            alert(args[0].message)
          else
            throw("Unknown request")
      else if message.response
        {clock, response} = message

        if result = response.result
          self.promises[clock].resolve(result)
        else if error = response.error
          self.promises[clock].reject(error)
        else
          throw("Unknown response")
      else
        throw("Unknown message")

  send: (query, args...) ->
    @socket.send({@clock, query, args})
    promise = new jQuery.Deferred
    @promises[@clock] = promise
    @clock++
    promise
