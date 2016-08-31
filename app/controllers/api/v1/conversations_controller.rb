class Api::V1::ConversationsController < ApplicationController
  def web_mobile
    @response = WebMobileService.new(permitted_params[:message]).call
  end

  private

  def permitted_params
    params.permit(:message)
  end
end
