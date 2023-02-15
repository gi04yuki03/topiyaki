Rails.application.routes.draw do
  devise_for :users
  root :to => 'homes#top'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :recipes do
    resources :favorites, only:[:create, :destroy]
  end
  resources :users, only:[:show, :edit, :destroy] do
    collection do
      get 'posted'
    end
    get :favorites, on: :collection
  end
end
