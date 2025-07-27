class Task < ApplicationRecord
  TODO = "to do"
  ONGOING = "ongoing"
  DONE = "done"
  STATES = [ TODO, ONGOING, DONE ].freeze

  has_many :task_users, dependent: :destroy
  has_many :users, through: :task_users

  validates :title, presence: true
  validates :state, presence: true
  validates :state, inclusion: { in: STATES }
end
