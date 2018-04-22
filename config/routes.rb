Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :makes do
        resources :models
      end

      resources :options

      resources :models, only: [] do
        post '/add_option', to: 'models#add_option'
      end
    end
  end
end
