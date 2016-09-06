Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'conversations/web_mobile'
      get "/webhook", to: "webhook#verify"
      post "/webhook", to: "webhook#handler"
      post "receive-sms", to: "conversations#receive_sms"
    end
  end
match '*path', to: redirect("https://andela-gogbara.github.io/genie-web/"), via: :all
end
