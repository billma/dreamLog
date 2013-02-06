class UserController < ApplicationController
  # get all users
  def all
    render :json => User.all
  end 
  # get user by id
  def get 
    render :json => User.find(params[:id])
  end 
  # edit user info
  def update
  end 
end
