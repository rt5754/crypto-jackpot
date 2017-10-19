class AddUsersArrayToJackpots < ActiveRecord::Migration[5.0]
  def change
    add_column :jackpots, :users, :text, default: [].to_yaml , array:true
  end
end
