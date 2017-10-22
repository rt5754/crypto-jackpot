class ChangeIdsInGamesToIntegers < ActiveRecord::Migration[5.0]
  def change
    change_column :games, :user_id, 'numeric USING CAST(user_id AS numeric)'
    change_column :games, :jackpot_id, 'numeric USING CAST(jackpot_id AS numeric)'
  end
end
