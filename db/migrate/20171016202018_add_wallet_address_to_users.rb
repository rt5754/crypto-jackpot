class AddWalletAddressToUsers < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :wallet_address, :string
  end
end
