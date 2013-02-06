class Reply < ActiveRecord::Base
  attr_accessible :body, :comment_id, :flag, :user_id
  belongs_to :user
  belongs_to :comment

end
