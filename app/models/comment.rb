class Comment < ActiveRecord::Base
  attr_accessible :body, :flag, :user_id
end
