class SetAllDecimalScalesTo6 < ActiveRecord::Migration[5.0]
  def change
    change_column :jackpots, :pot, :decimal, :precision => 10, :scale => 6, :default => 0.0000
    change_column :games, :user_stake , :decimal, :precision => 10, :scale => 6, :default => 0.0000
    change_column :users, :balance, :decimal, :precision => 10, :scale => 6, :default => 0.0000
  end
end
