LsTechEvents::Application.routes.draw do
  root 'events#index'

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"

  resources :users, :only => [:create, :show]

  resources :sessions

  resources :events do
    collection do
      get :export, :defaults => { :format => 'json' }
    end
  end
end
