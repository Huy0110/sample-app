class Micropost < ApplicationRecord
  belongs_to :user

  delegate :name, to: :user, prefix: true

  has_one_attached :image do |attachable|
    attachable.variant :display,
                       resize_to_limit: Settings.micropost.resize_to_limit
  end

  scope :ordered_by_created_at, ->{order(created_at: :desc)}
  validates :content, presence: true, length: {maximum: Settings.length_255}
  validates :image,
            content_type: {in: Settings.micropost.image_type,
                           message: :validate_type},
            size: {less_than: Settings.file_size_5.megabytes}

  def display_image
    image.variant resize_to_limit: Settings.micropost.resize_to_limit
  end
end
