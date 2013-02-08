class Comment < ActiveRecord::Base
  attr_accessible :body, :flag, :user_id, :log_id
  belongs_to :user
  belongs_to :log
  has_many :replies, :dependent=> :destroy
end
