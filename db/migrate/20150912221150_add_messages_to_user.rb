class AddMessagesToUser < ActiveRecord::Migration
  def change
    add_column :users, :messages, :text,Array
  end
end
