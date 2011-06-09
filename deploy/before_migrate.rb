base_url = case node["environment"]["name"]
when "production"
  "http://mastery.spork.in"
end
run "echo -n '#{base_url}' >#{latest_release}/config/base_url"
