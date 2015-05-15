class User < ActiveRecord::Base
  has_secure_password
  has_paper_trail
  validates_uniqueness_of :email
  validates_presence_of :email, :on => :create
  before_create { generate_token(:auth_token) }
  
  def generate_token(column)
    begin
      self[column] = SecureRandom.urlsafe_base64
    end while User.exists?(column => self[column])
  end
end
