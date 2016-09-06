class TextMessage
  def self.send_text(message, phone_number)
    # puts phone_number
    # puts message
    client = Twilio::REST::Client.new
    client.messages.create(
      from: '+12562174391',
      to: phone_number,
      body: message
    )
  end
end
