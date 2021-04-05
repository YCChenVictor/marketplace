class RenameProjectToProduct < ActiveRecord::Migration[6.1]
  def change
    rename_table :projects, :products
    rename_column :products, :donation_goal, :price
    rename_column :products, :current_donation_amount, :current_available_amount
  end
end
