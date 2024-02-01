class Task < ApplicationRecord
  extend Enumerize

  belongs_to :project

  validates :name, presence: true
  validates :status, presence: true

  scope :recent, -> { order(created_at: :desc) }
  scope :with_status, ->(status) { where(status: status) if status.present? }

  enumerize :status,
    in: %i[new in_progress completed],
    default: :new

  def self.valid_status?(status)
    Task.status.value?(status)
  end
end
