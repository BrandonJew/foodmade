class AddIndexToRecipientsEmail < ActiveRecord::Migration
  def change
    add_index :recipients, :email, unique: true
  end
end
