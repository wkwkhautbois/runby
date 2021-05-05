class Execution < ApplicationRecord
  validates :program, presence: true, length: { maximum: 8000 }
  validates :input, length: { maximum: 1000 }
end
