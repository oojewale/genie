Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      get 'conversations/web_mobile'
    end
  end
end
