class User < ActiveRecord::Base
  attr_accessor :activation_token
  before_create :create_activation_token
  
  has_many :ads
  has_many :tasks
  
  validates :name, presence: true, length: {maximum: 10}
  validates :email, presence: true 
  
  has_secure_password
  validates :password, length: { minimum: 6 }
  
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)   
  end
  
  
  private
  
  def create_activation_token
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
    self.activation_token  = SecureRandom.urlsafe_base64
    self.activation_digest = BCrypt::Password.create(self.activation_token, cost: cost)
  end

end
