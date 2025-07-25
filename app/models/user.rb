# Unit tested in spec/models/user_spec.rb
class User < ApplicationRecord
  has_secure_password

  validates :email, presence: true,
                   uniqueness: { case_sensitive: false },
                   format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :pseudo, presence: true, uniqueness: true

  before_save { self.email = email.downcase }
end
