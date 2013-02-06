class LogController < ApplicationController

  def all
    render :json=> Log.all
  end 
  def create
    n=Log.create({
      :title=>params[:title],
      :body=>params[:body],
      :user_id=>current_user.id
    })

    render :json=> n
  end 
  def update
  end 
  def destroy
  end 
end
