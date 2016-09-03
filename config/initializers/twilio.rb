Twilio.configure do |config|
  cred = JSON.parse(ENV["VCAP_SERVICES"])["user-provided"].select{|e| e["name"] == "Twilio-y4"}.first["credentials"]

  config.account_sid = cred["accountSID"]
  config.auth_token = cred["authToken"]
end
