class ChangeUsersBalanceToDecimal < ActiveRecord::Migration[5.0]
  def change
    change_column :users, :balance, :decimal, :precision => 10, :scale => 6, :default => 0
  end
end
