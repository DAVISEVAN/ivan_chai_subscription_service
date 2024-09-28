class Subscription < ApplicationRecord
  belongs_to :customer
  belongs_to :tea

  enum status: { active: 0, cancelled: 1 }

  validates :title, :price, :frequency, presence: true
  validates :status, inclusion: { in: statuses.keys, message: 'is not included in the list' }
end