class Advert < ApplicationRecord
  has_one_attached :car_foto

  scope :after, ->(date) { where('created_at >= ?', date) }
  scope :before, ->(date) { where('created_at <= ?', date) }
  scope :greater, ->(amount) { where('price >= ?', amount) }
  scope :lower, ->(amount) { where('price <= ?', amount) }

  validates_presence_of :description, :title, :price, :car_foto
  validate :picture_type_valid?


  private

  def picture_type_valid?
    return if car_foto.attached? && car_foto.content_type == 'image/jpeg'

    errors.add(:picture, 'attached is not in a supported format')
  end
end
