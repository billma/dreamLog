class LogController < ApplicationController

  def index
    render :json=> Log.all
  end 
  def create
    printa params
    n=Log.create({
      :title=>params[:title],
      :body=>params[:body],
      :user_id=>current_user.id
    })
    render :json=> n
  end 
  def update
    log=Log.find(params[:log_id])
    log.update_attributes(:body => params[:body], :title => params[:title])
    render :json=> log 
  end 
  def destroy 
    Log.find(params[:id]).destroy()
    render :text=> 'success'
  end 
end
