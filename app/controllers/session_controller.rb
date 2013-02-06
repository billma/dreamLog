class SessionController < ApplicationController
  def create
    user = User.from_omniauth(env['omniauth.auth'])
    session[:user_id]=user.id
    redirect_to '/home'
  end 
  def destroy
  end
end
