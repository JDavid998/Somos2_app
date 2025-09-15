Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout',
    sign_up: 'register'
  }
  
  
  root 'home#index'
  
  
  get 'dashboard', to: 'dashboard#index'
  
 
  resources :technicians
  resources :installations do
    member do
      patch :assign      
      patch :complete    
      patch :cancel     
    end
  end
  
  
  resources :schedules, only: [:index, :show] do
    collection do
      get :technician, as: 'technician_schedule'  # /schedules/technician?technician_id=X
    end
  end
  # Rutas de salud
  get "up" => "rails/health#show", as: :rails_health_check
end
