class AddChefRequestToUsers < ActiveRecord::Migration
  def change
    add_column :users, :request, :boolean, default: false
  end
end
