class Log < ActiveRecord::Base
  attr_accessible :body, :title, :user_id
  belongs_to :user
  has_many :comments,:dependent => :destroy
end
