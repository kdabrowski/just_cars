class Advert < ApplicationRecord
  has_one_attached :car_foto

  scope :after, ->(date) { where('created_at >= ?', date) }
  scope :before, ->(date) { where('created_at <= ?', date) }
  scope :greater, ->(amount) { where('price >= ?', amount) }
  scope :lower, ->(amount) { where('price <= ?', amount) }
end
