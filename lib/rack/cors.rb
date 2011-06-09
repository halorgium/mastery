module Rack
  class Cors
    def initialize(app)
      @app = app
    end

    def call(env)
      if env["REQUEST_METHOD"] == "OPTIONS"
        headers = {
          "Content-Type" => "text/plain",
          "Access-Control-Allow-Origin" => "*",
          "Access-Control-Allow-Methods" => "GET, PUT",
          "Access-Control-Allow-Headers" => env["HTTP_ACCESS_CONTROL_REQUEST_HEADERS"] || "",
        }
        [200, headers, [""]]
      else
        status, headers, body = @app.call(env)
        if origin = env["HTTP_ORIGIN"]
          headers["Access-Control-Allow-Origin"] = origin
        end
        [status, headers, body]
      end
    end
  end
end
