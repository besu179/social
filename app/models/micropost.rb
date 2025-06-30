class Micropost < ApplicationRecord
  belongs_to :user, optional: false
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true
  validate :user_must_exist
  validate :content_length

  # Returns microposts from the user and the users they follow.
  def self.from_users_followed_by(user)
    followed_user_ids = user.following.pluck(:id)
    where(user_id: followed_user_ids << user.id)
          .order(created_at: :desc)
          .includes(:user) # Prevent N+1 query
  end

  private

  # Prevents microposts from being created without a user
  def user_must_exist
    errors.add(:user_id, "must exist") unless User.exists?(id: user_id)
  end

  # Prevents microposts longer than 140 characters
  def content_length
    errors.add(:content, "must be less than 140 characters") if content.present? && content.length > 140
  end
end
