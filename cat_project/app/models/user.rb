class User < ActiveRecord::Base
  attr_accessible :user_name, :session_token

  before_validation :ensure_session_token

  #add uniqueness validations to everything

  def self.find_by_credentials(user_name, password)
    user = User.where("user_name = ?", user_name)
    if user.password_digest.is_password?(password)
      user
    else
      nil #maybe raise an error here
    end
  end

  def ensure_session_token
    @session_token ||= reset_session_token!
  end

  def reset_session_token!
    @session_token = SecureRandom::urlsafe_base64(16)
  end

  def password=(password)
    @password_digest = BCrypt::Password.create(password)
  end

  def is_password?(password)
    @password_digest.is_password?(password)
  end

end
