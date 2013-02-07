class ReplyController < ApplicationController
  def all
    render :json => Reply.all
  end 
  def create
    r= Reply.create({
      body:params[:body],
      user_id:current_user.id,
      comment_id:params[:comment_id],
      flag:false
    })
    render :json=> r
  end 
end
