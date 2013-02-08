class User < ActiveRecord::Base
  attr_accessible :email, :name, :thumb_url, :uid
  has_many :comments,:dependent => :destroy
  has_many :replies, :dependent => :destroy
  has_many :logs,:dependent => :destroy
  has_many :votes,:dependent => :destroy


  def self.from_omniauth(auth)
     where(auth.slice(:uid)).first_or_initialize.tap do |user|
      user.name = auth.info.name
      user.email= auth.info.email
      user.thumb_url=auth.info.image
      user.save!
    end
  end 
end
