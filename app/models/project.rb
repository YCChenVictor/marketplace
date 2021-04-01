class Project < ApplicationRecord
  belongs_to :user
  has_rich_text :description
  has_one_attached :thumbnail # also can be has_many_attached
  has_many :comments, as: :commentable

  def active?
    status == "active"
  end

  def inactive
    status == "inactive"
  end

end
