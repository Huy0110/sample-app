class User < ApplicationRecord
  before_save{self.email.downcase!}

  validates :name, presence: true,
    length: {maximum: Settings.validate.digits.length_50}
  validates :email, presence: true,
    length: {maximum: Settings.validate.digits.length_255},
    format: {with: Settings.validate.email_regex},
    uniqueness: true
  validates :password, presence: true, length: {minimum: Settings.validate.digits.length_6}

  has_secure_password
end
