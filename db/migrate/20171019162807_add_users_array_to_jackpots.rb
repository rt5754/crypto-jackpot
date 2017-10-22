class AddUsersArrayToJackpots < ActiveRecord::Migration[5.0]
  def change
    add_column :jackpots, :users, :text , array:true, default: []
  end
end
