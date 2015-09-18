class CreateReservations < ActiveRecord::Migration
  def change
    create_table :reservations do |t|
      t.integer :user_id
      t.string :time
      t.text :order
      t.decimal :price
      t.boolean :confimation

      t.timestamps null: false
    end
  end
end
