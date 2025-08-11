class Comment < ApplicationRecord
  belongs_to :article
  belongs_to :user

  validates :content, presence: true
  validates :user, presence: true
  validates :article, presence: true

end
