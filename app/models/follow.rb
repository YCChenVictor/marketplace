class Follow < ApplicationRecord
  belongs_to :follower, class_name: 'User'
  belongs_to :followee, class_name: 'User'

  validate :not_following_self
  private
    def not_following_self
      if follower_id == followee_id
        errors.add(:follower_id, 'You cannot follow yourself')
      end
    end
end
