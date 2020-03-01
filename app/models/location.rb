class Location < ApplicationRecord
  belongs_to :user
  has_many :marks

  def self.search(search)
    where('content LIKE ? OR content LIKE ?', "%#{search}%")
  end
end
