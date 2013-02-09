class PagesController < ApplicationController
  def home
    if !current_user
      redirect_to '/'
     end
  end
  def login
  end 
  def test
  end 
end
