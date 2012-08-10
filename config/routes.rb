QuriTest::Application.routes.draw do
  root to: 'pages#home'

  resources :mobile_sessions, only: [:create, :index] do
    resources :mobile_events, only: :create
  end
  namespace :admin do
    root to: 'pages#home'
  end
end
