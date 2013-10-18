Easyblog::Application.routes.draw do
  authenticated :user do
    root :to => 'home#index'
  end
  root :to => "home#index"
  devise_for :users
  resources :users
  resources :posts do
    member do
      post :mark_archived
    end
    resources :comments do
      post :vote_up
      post :vote_down
      post :mark_not_abusive
    end
  end
end
