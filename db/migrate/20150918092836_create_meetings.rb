class CreateMeetings < ActiveRecord::Migration
  def change
    create_table :meetings do |t|
      t.datetime :time
      t.boolean :reserved, default: false
      t.integer :user_id

      t.timestamps null: false
    end
  end
end
