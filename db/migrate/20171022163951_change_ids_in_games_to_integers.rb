class ChangeIdsInGamesToIntegers < ActiveRecord::Migration[5.0]
  def change
    change_column :games, :user_id, :integer
    change_column :games, :jackpot_id, :integer
  end
end
