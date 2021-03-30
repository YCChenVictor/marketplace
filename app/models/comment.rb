class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :commentable, polymorphic: true # with only one line, all model can have it
end
