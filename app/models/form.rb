class Form < ApplicationRecord
  extend FriendlyId
  friendly_id :title, use: :slugged

  belongs_to :user
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy

  validates :title, :description, :user, presence: true
  validates :title, uniqueness: { scope: :user_id } 

end
