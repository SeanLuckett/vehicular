Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :makes do
        resources :models
      end

      resources :options
    end
  end
end
