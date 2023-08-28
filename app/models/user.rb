class User < ApplicationRecord
  attr_accessor :remember_token, :activation_token, :reset_token

  before_save{email.downcase!}
  before_create :create_activation_digest

  has_many :microposts, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.validate.digits.length_50}
  validates :email, presence: true,
    length: {maximum: Settings.validate.digits.length_255},
    format: {with: Settings.validate.email_regex},
    uniqueness: true
  validates :password, presence: true,
length: {minimum: Settings.validate.digits.length_6}, allow_nil: true

  has_secure_password

  def feed
    micropost
  end

  class << self
    # Returns the hash digest of the given string.
    def digest string
      cost = if ActiveModel::SecurePassword.min_cost
               BCrypt::Engine::MIN_COST
             else
               BCrypt::Engine.cost
             end
      BCrypt::Password.create(string, cost:)
    end

    # Returns a random token.
    def new_token
      SecureRandom.urlsafe_base64
    end
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
    remember_digest
  end

  # Returns true if the given token matches the digest.
  def authenticated? attribute, token
    digest = send "#{attribute}_digest"
    return false if digest.nil?

    BCrypt::Password.new(digest).is_password? token
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  def session_token
    remember_digest || remember
  end

  def activate
    update_columns activated: true, activated_at: Time.now
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update reset_digest: User.digest(reset_token),
           reset_sent_at: Time.now
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < Setting.expired_2.hours.ago
  end

  private

  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest activation_token
  end
end
