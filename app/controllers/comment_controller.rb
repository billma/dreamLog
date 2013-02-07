class CommentController < ApplicationController
  def all
    render :json => Comment.all
  end 
  def create
    printa params
    c= Comment.create({
      body:params[:body],
      user_id:current_user.id,
      flag:false,
      log_id:params[:log_id]
    }) 
    render :json => c 
  end 
end
