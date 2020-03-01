class Location < ApplicationRecord
  belongs_to :user

  def self.search(search)
    where('content LIKE ? OR content LIKE ?', "%#{search}%")
  end
end
