class Customer < ApplicationRecord
  has_many :subscriptions
  validates :email, presence: true, uniqueness: true

end
