class CreateGames < ActiveRecord::Migration[5.0]
  def change
    create_table :games do |t|
      t.string :user_id
      t.string :integer
      t.string :jackpot_id
      t.string :integer

      t.timestamps
    end
  end
end
