class User < ApplicationRecord
  has_secure_password

  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }

  def self.authenticate_with_credentials(email, password)
    user = User.where('LOWER(email) = ?', email.strip.downcase).first
    user && user.authenticate(password)
  end
end
