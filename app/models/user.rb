class User < ApplicationRecord
  before_save{self.email.downcase!}
  validates :name, presence: true, length:
  {
    maximum: Settings.validate.name.length.max
  }
  validates :email, presence: true, length:
  {
    maximum: Settings.validate.email.length.max
  },
                    format: {with: Settings.validate.VALID_EMAIL_REGEX},
                    uniqueness: true
  has_secure_password
  validates :password, presence: true, length:
  {
    minimum: Settings.validate.password.length.min
  }
end
