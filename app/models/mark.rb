class Mark < ApplicationRecord
  belongs_to :mark_type
  belongs_to :user
end
