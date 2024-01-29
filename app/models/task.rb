class Task < ApplicationRecord
  extend Enumerize

  belongs_to :project

  validates :name, presence: true
  validates :status, presence: true

  enumerize :status,
    in: %i[new in_progress completed],
    default: :new
end
