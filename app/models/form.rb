class Form < ApplicationRecord
  extend FriendlyId
  friendly_id :title, user: :slugged
  belongs_to :user
end
