class Micropost < ApplicationRecord
  belongs_to :user
  validates :content, presence: true, length: { maximum: 140 }
  validates :user_id, presence: true

  # Returns microposts from the user and the users they follow.
  def self.from_users_followed_by(user)
    followed_user_ids = "SELECT followed_id FROM relationships
                         WHERE follower_id = :user_id"
    where("user_id IN (#{followed_user_ids}) OR user_id = :user_id",
          user_id: user.id)
          .order(created_at: :desc)
  end
end
