Rails.application.routes.draw do

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  namespace :api do
    namespace :v1  do
      # resources :thermostat
      # resources :readings

      post 'readings/:token', to: 'readings#create'

      get 'readings/:token', to: 'readings#show'

      get 'stats/:token', to: 'readings#stats'
    end
  end
end
