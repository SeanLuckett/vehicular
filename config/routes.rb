Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :makes do
        resources :models
      end

      resources :options

      resources :models, only: [] do
        post '/add_option', to: 'models#add_option'
        post '/remove_option', to: 'models#remove_option'

        resources :vehicles, shallow: true do
          post '/add_option', to: 'vehicles#add_option'
          post '/remove_option', to: 'vehicles#remove_option'
        end
      end
    end
  end
end
