class User < ActiveRecord::Base
  
  has_secure_password

  # add dependent destroy to destroy posts associated with users
  has_many :posts, dependent: :destroy
  
  has_one :profile, dependent: :destroy

  validates :email, uniqueness: true

end
