require 'bcrypt'
class User < ActiveRecord::Base
   has_many :caches 
   validates :email, presence: true, uniqueness: true 
   validates :password, presence: true
   validates :name, presence: true
   
  # users.password_hash in the database is a :string
  include BCrypt

  def password
    @password ||= Password.new(password_hash)
  end

  def password=(new_password)
    @password = Password.create(new_password)
    self.password_hash = @password
  end
end