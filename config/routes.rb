QuriTest::Application.routes.draw do
  root to: 'pages#home'

  resources :mobile_sessions, only: :create do
    resources :mobile_events, only: :create
  end
end
