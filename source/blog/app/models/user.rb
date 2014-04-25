require 'bcrypt'

class User < ActiveRecord::Base
  include BCrypt
  before_save :encrypt_password

  has_many :posts

  validates :email, uniqueness: true

  def self.authenticate(email, password)
    user = find_by_email(email)
    if user && Password.new(user.password) == password
      user
    else
      nil
    end
  end

  private

    def encrypt_password
      self.password = Password.create(password, :cost => 4) if password.present?
    end
end
