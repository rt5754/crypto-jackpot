class CreateJackpots < ActiveRecord::Migration[5.0]
  def change
    create_table :jackpots do |t|
      t.float :pot
      t.boolean :open

      t.timestamps
    end
  end
end
