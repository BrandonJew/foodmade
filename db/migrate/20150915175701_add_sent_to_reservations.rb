class AddSentToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :sent, :boolean
  end
end
