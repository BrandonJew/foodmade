class AddMenuToUsers < ActiveRecord::Migration
  def change
    add_column :users, :menu, :text
  end
end
