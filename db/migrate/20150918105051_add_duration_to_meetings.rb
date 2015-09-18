class AddDurationToMeetings < ActiveRecord::Migration
  def change
    add_column :meetings, :duration, :integer
  end
end
