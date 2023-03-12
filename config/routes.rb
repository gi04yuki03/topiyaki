Rails.application.routes.draw do
  devise_for :users, controllers: {
    registrations: 'users/registrations',
    passwords: 'users/passwords'
  }
  root to: 'homes#top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :recipes do
    resources :favorites, only: [:create, :destroy]
    resources :comments,  only: [:create, :destroy]
  end
  resources :users, only: [:show, :edit, :update, :destroy] do
    collection do
      get 'posted'
      get 'favorites'
    end
  end
  post '/homes/guest_sign_in', to: 'homes#guest_sign_in'
  devise_scope :user do
    post 'users/guest_sign_in', to: 'users/sessions#guest_sign_in'
  end
end
