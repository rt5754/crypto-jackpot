class Jackpot < ApplicationRecord
  has_many :games
  has_many :users, :through => :games
  attr_accessor :amount
end
