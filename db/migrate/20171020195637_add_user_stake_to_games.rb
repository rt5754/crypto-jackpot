class AddUserStakeToGames < ActiveRecord::Migration[5.0]
  def change
    add_column :games, :user_stake, :decimal, precision: 10, scale: 4, default: "0.0"
  end
end
