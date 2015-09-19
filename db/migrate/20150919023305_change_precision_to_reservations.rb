class ChangePrecisionToReservations < ActiveRecord::Migration
  def change
     change_column :reservations, :price, :decimal, :precision => 5, :scale => 3
  end
end
