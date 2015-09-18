class AddUserIdsToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :sender_id, :integer
    add_column :reservations, :receiver_id, :integer
  end
end
