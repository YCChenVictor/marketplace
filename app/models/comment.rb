class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true # with only one line, all model can have it
  has_many   :replies, class_name: 'Comment', foreign_key: :commentable_id, dependent: :destroy
end
