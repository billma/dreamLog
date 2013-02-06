class Vote < ActiveRecord::Base
  attr_accessible :log_id, :user_id
  belongs_to :user
  belongs_to :log
end
