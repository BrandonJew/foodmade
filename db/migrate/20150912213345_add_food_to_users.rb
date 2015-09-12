class AddFoodToUsers < ActiveRecord::Migration
  def change
    add_column :users, :food, :string, default: nil
  end
end
