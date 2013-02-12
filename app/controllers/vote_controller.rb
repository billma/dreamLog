class VoteController < ApplicationController
 def index
   render :json=>Vote.all
 end 

 def create
   v=Vote.create({
     :user_id=>current_user.id,
     :log_id=>params[:log_id]
   })
   render :json=> v
 end 

 def update
 end

 def destroy
   Vote.find(params[:id]).destroy()
   render :text=>"success"
 end 

end
