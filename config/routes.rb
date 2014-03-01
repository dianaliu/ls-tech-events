LsTechEvents::Application.routes.draw do
  root 'events#index'

  get "logout" => "sessions#destroy", :as => "logout"
  get "login" => "sessions#new", :as => "login"
  get "signup" => "users#new", :as => "signup"

  resources :users do
    collection do
      post :toggle_subscribed
    end
  end

  resources :sessions

  resources :events do
    collection do
      get :export, :defaults => { :format => 'json' }
    end
  end

  scope :module => 'welcome' do
    get 'about'
  end
end
