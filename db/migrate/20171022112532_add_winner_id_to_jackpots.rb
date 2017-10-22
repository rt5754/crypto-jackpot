class AddWinnerIdToJackpots < ActiveRecord::Migration[5.0]
  def change
    add_column :jackpots, :winner_id, :integer
  end
end
