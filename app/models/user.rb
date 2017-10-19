class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :wallet_address, presence: true, uniqueness: true, length: {is: 42};
  has_many :games
  has_many :jackpots, :through => :games
end
