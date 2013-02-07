DreamLog::Application.routes.draw do

  root :to => 'pages#login'
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

  #logs 
  match 'logs'=>'log#all'
  match 'log/create'=>'log#create'

  #comments
  match 'comments'=>'comment#all'
  match 'comment/create'=>'comment#create'
  
  #repllies
  match 'replies'=>'reply#all'
  match 'reply/create'=>'reply#create'


end
