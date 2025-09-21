Rails.application.routes.draw do
  devise_for :users, path: '', path_names: {
    sign_in: 'login',
    sign_out: 'logout'
  }, skip: [:registrations]
  
  
  root 'home#index'
  
  
  get 'dashboard', to: 'dashboard#index'
  
  resources :admins, only: [:index, :new, :create, :destroy]
  resources :technicians
  patch 'installations/assign', to: 'installations#assign', as: :assign_installation
  
  resources :installations do
    member do
      patch :complete    
      patch :cancel     
      patch :start
      patch :finish
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
