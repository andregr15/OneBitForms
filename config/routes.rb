Rails.application.routes.draw do

  namespace :api do
    namespace :v1 do
      mount_devise_token_auth_for 'User', at: 'auth'
      resources :forms
      patch '/questions', to: 'questions#reorder'
      resources :questions, only: [:create, :update, :destroy, :index]
      resources :answers, only: [:index, :show, :create, :destroy]
    end
  end
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
