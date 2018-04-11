Rails.application.routes.draw do
  resources :cards
  resources :lists do
    member do
      patch :move
    end
  end
  
  resources :cards do
    member do
      patch :move
    end
  end


  root to: 'lists#index'
end
