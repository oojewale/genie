Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'conversations/web_mobile'
      get "/webhook", to: "webhook#verify"
      post "/webhook", to: "webhook#handler"
      post 'schedule/create'
    end
  end
end
