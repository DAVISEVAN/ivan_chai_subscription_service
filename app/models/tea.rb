class Tea < ApplicationRecord
  has_many :subscriptions

  validates :title, :description, :temperature, :brew_time, presence: true
end
