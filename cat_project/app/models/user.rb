require 'bcrypt'

class User < ActiveRecord::Base
  attr_accessible :user_name, :session_token, :password
  before_validation :ensure_session_token
  validates :password_digest, presence: true
  validates :password, length: { minimum: 2, allow_nil: true }
  validates :user_name, :session_token, uniqueness: true

  has_many(
    :cats,
    class_name: "Cat",
    foreign_key: :user_id,
    primary_key: :id
  )

  def self.find_by_credentials(user_name, password)
    user = User.where("user_name = ?", user_name)
    if user.password_digest.is_password?(password)
      user
    else
      nil
    end
  end

  def ensure_session_token
    self.session_token ||= SecureRandom::urlsafe_base64(16)
  end

  def reset_session_token!
    self.session_token = SecureRandom::urlsafe_base64(16)
    self.update_attributes(session_token: @session_token)
  end

  def password=(password)
    if password == ""
      return nil
    else
      self.password_digest = BCrypt::Password.create(password)
    end
  end

  def password
    @password
  end

  def is_password?(password)
    @password_digest.is_password?(password)
  end

end
