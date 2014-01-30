LsTechEvents::Application.routes.draw do
  root 'events#index'
  resources :events do
    collection do
      get :export, :defaults => { :format => 'json' }
    end
  end
end
