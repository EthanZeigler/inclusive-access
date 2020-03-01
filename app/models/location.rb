class Location < ApplicationRecord
  belongs_to :user
  has_many :marks

  def self.search(search)
    where('name LIKE ? OR description LIKE ?', "%#{search}%", "%#{search}%")
  end
end
