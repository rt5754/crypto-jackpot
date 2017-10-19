class RemoveUsersArray < ActiveRecord::Migration[5.0]
  def change
    remove_column :jackpots, :users
  end
end
