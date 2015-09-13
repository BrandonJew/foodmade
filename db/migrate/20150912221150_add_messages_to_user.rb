class AddMessagesToUser < ActiveRecord::Migration
  def change
    add_column :users, :messages, :text, array: true
  end
end
