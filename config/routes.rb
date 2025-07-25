# config/routes.rb
Rails.application.routes.draw do
  devise_for :users

  # Handle OPTIONS requests for CORS
  match '*path', via: :options, to: proc { [200, {'Access-Control-Allow-Origin' => '*', 'Access-Control-Allow-Methods' => 'GET, POST, OPTIONS', 'Content-Type' => 'text/plain'}, ['']] }

  # Main domain routes
  constraints subdomain: '' do
    root 'home#index'
    get '/about', to: 'home#about'
  end

  # Manager subdomain routes (for non-admin users)
  constraints subdomain: 'manage' do
    scope module: 'manage' do
      root 'dashboard#index', as: 'manage_root'
      resources :users, only: [:index, :show, :edit, :update]
      resources :reports
    end
  end

  # Admin subdomain routes (for admin users only)
  constraints subdomain: 'admin' do
    scope module: 'admin' do
      root 'dashboard#index', as: 'admin_root'
      resources :users
      resources :settings
      resources :system_logs, only: [:index, :show]
    end
  end
end