class User < ApplicationRecord
  before_save { self.email = email.downcase }

  attr_accessor :remember_token, :password_confirmation
  has_secure_password

  validates :name, presence: true, length: { maximum: 50 }

  validates :email, presence: true, length: { maximum: 255 },
                    format: { with: URI::MailTo::EMAIL_REGEXP },
                    uniqueness: { case_sensitive: false }

  validates :password, presence: true, length: { minimum: 6 }, if: -> { new_record? || password.present? }
  validates :password_confirmation, presence: true, if: -> { new_record? || password.present? }
  validates :activated_at, presence: true, if: :activated?

  has_many :microposts, dependent: :destroy
  has_many :active_relationships, class_name:  "Relationship",
                                  foreign_key: "follower_id",
                                  dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                 foreign_key: "followed_id",
                                 dependent:   :destroy
  has_many :following, through: :active_relationships, source: :followed
  has_many :followers, through: :passive_relationships, source: :follower

  # Returns the hash digest of the given string.
  def User.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                          BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  # Returns a random token.
  def User.new_token
    SecureRandom.urlsafe_base64
  end

  # Remembers a user in the database for use in persistent sessions.
  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  # Creates and assigns the activation token and digest.
  def create_activation_digest
    self.activation_token = User.new_token
    self.activation_digest = User.digest(activation_token)
    save
  end

  # Creates and assigns the password reset token and digest.
  def create_reset_digest
    self.reset_token = User.new_token
    self.reset_digest = User.digest(reset_token)
    self.reset_sent_at = Time.zone.now
    save
  end

  # Sends activation email.
  def send_activation_email
    UserMailer.with(user: self).account_activation.deliver_now
    save
  end

  # Sends password reset email.
  def send_password_reset_email
    UserMailer.with(user: self).password_reset.deliver_now
    save
  end

  # Returns true if a password reset has expired.
  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  # Activates an account.
  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  # Returns true if the given token matches the digest.
  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  # Forgets a user.
  def forget
    update_attribute(:remember_digest, nil)
  end

  # Forgets activation token.
  def forget_activation
    update_attribute(:activation_token, nil)
  end

  # Forgets password reset token.
  def forget_reset
    update_attribute(:reset_token, nil)
    update_attribute(:reset_sent_at, nil)
  end

  # Returns true if the user has been activated.
  def activated?
    activated_at.present?
  end

  # Returns a user's status feed.
  def feed
    Micropost.from_users_followed_by(self)
  end

  # Follows a user.
  def follow(other_user)
    following << other_user
  end

  # Unfollows a user.
  def unfollow(other_user)
    following.delete(other_user)
  end

  # Returns true if the current user is following the other user.
  def following?(other_user)
    following.include?(other_user)
  end
end
