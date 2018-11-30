Rails.application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: 'users/omniauth_callbacks'}
  devise_scope :user do
  get '/users/sign_out' => 'devise/sessions#destroy'
  end
  root to: 'pages#home'
  resources :gyms, only: [:index, :show] do
    resource :bookmarks, only: [:create, :destroy]
    resources :reviews, only: :create
    # resources :events, only: :create
    resources :events
  end
  resources :bookmarks, only: :index
  # resources :events, except:[:create]

  resources :conversations do
  resources :messages
  end
  get :search, controller: :main
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
#
