QuriTest::Application.routes.draw do
  root to: 'pages#home'

  resources :mobile_sessions, only: [:create, :index] do
    resources :mobile_events, only: :create
  end
  resources :mobile_events, only: :index
  namespace :admin do
    root to: 'pages#home'
  end
end
