class AddParamsStatusTransactionIdPurchasedAtToReservations < ActiveRecord::Migration
  def change
    add_column :reservations, :notification_params, :text
    add_column :reservations, :status, :string
    add_column :reservations, :transaction_id, :string
    add_column :reservations, :purchased_at, :datetime
    add_column :reservations, :paid, :boolean, default: false
  end
end
