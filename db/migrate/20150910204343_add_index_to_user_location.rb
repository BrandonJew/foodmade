class AddIndexToUserLocation < ActiveRecord::Migration
  def self.up
    add_index  :pages, [:lat, :lng]
  end

  def self.down
    remove_index  :pages, [:lat, :lng]
  end
=begin 
 def change
    add_index  :users, [:lat, :lng]
  end
=end
end
