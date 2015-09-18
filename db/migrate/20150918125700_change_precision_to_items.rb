class ChangePrecisionToItems < ActiveRecord::Migration
  def change
   change_column :items, :price, :decimal, :precision => 5, :scale => 3
  end
end
