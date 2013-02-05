class User < ActiveRecord::Base
  attr_accessible :email, :name, :thumb_url
end
