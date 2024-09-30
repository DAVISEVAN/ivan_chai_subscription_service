Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      resources :customers, only: [] do
        resources :subscriptions, only: [:create, :index, :update, :show, :destroy]
      end
    end
  end
end