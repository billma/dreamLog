DreamLog::Application.routes.draw do

  root :to => 'pages#login'
  match 'test' => 'pages#test'

  match 'home' => 'pages#home'
  
  #session
  match 'auth/failure', to: redirect('/')
  match 'auth/:provider/callback' => 'session#create'
  match 'logout' => 'session#destroy', as:'logout'
  #users
  match 'users'=>'user#all'
  match 'users/:id'=>'user#get'

  #logs 
  match 'logs'=>'log#all'
  match 'log/create'=>'log#create'

  #reply
  match 'replies'=> 'reply#all'


end
