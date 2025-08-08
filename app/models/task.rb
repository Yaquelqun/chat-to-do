class Task < ApplicationRecord
  TODO = "todo"
  ONGOING = "ongoing"
  DONE = "done"
  STATES = [ TODO, ONGOING, DONE ].freeze

  has_many :task_users, dependent: :destroy
  has_many :users, through: :task_users

  # useless but kinda fun
  # dynamically defines scopes for every state
  class << self
    STATES.each do |state|
      define_method(state.to_sym) { where(state:) }
    end
  end

  validates :title, presence: true
  validates :state, presence: true
  validates :state, inclusion: { in: STATES }
end
