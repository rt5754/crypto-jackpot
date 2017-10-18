class AddBalanceAndJackpotIdToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :balance, :float
    add_column :users, :jackpot_id, :integer
  end
end
