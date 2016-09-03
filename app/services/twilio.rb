class TextMessage
  def self.send_text(phone_number, message)
    client = Twilio::REST::Client.new
    client.messages.create(
      from: '+12562174391',
      to: phone_number,
      body: message
    )
  end
end
