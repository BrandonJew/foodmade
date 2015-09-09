class AddChefToUsers < ActiveRecord::Migration
  def change
    add_column :users, :chef, :boolean, default: false
  end
end
