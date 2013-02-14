DreamLog::Application.routes.draw do
  root :to => 'pages#login'
  resources :log
  resources :vote
  resources :comment
  resources :reply
  match 'test' => 'pages#test'
  match 'home' => 'pages#home'
  #session
  match 'auth/failure', to: redirect('/')
  match 'auth/:provider/callback' => 'session#create'
  match 'logout' => 'session#destroy', as:'logout'
  #users
  match 'current'=>'user#current'
  match 'users'=>'user#all'
  match 'users/:id'=>'user#get'

end
