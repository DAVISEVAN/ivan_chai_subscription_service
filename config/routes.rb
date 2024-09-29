Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers, only: [] do
        resources :subscriptions, only: [:create, :index, :update, :show]
      end
    end
  end
end