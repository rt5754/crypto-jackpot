class Game < ApplicationRecord
  belongs_to :user
  belongs_to :jackpot
  validates :user_stake, presence: true
end
