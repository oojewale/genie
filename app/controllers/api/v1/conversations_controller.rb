class Api::V1::ConversationsController < ApplicationController
  before_action :setup_watson

  def web_mobile
    msg = permitted_params[:message] || ""
    convo_key = permitted_params[:token]
    @watson.prepare_payload(convo_key, msg)
    reply = @watson.send_to_watson

    response = { text: reply, image: @watson.image }
    render json: response
  end

  def recieve_sms
    response = Twilio::TwiML::Response.new do |r|
      r.Message do |b|
        b.Body sms_response
      end
    end
    render xml: response.text
  end

  private

  def sms_response
    msg = params["Body"] || ""
    convo_key = params["From"]
    @watson.prepare_payload(convo_key, msg)
    reply = @watson.send_to_watson
  end

  def permitted_params
    params.permit(:message)
  end

  def setup_watson
    @watson = WatsonConversationService.setup
  end
end
