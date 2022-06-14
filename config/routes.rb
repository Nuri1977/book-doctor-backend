Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :v1 do
    post 'users/login' => 'users#login'
    post 'users/signup' => 'users#signup'
    get 'users/fetch_current_user' => 'users#fetch_current_user'
    resources :doctors, only: [:create, :destroy, :show, :index]
    resources :appointments, only: [:create, :show, :destroy, :index]
  end
end
