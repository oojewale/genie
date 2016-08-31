require 'rails_helper'

RSpec.describe Api::V1::ConversationsController, type: :controller do

  describe "GET #web_mobile" do
    it "returns http success" do
      get :web_mobile
      expect(response).to have_http_status(:success)
    end
  end

end
