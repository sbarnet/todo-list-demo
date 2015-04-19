class User < ActiveRecord::Base
  
  
  has_many :ads
  
  validates :name, presence: true, length: {maximum: 10}
  validates :email, presence: true 
  
  has_secure_password
  
  

end
