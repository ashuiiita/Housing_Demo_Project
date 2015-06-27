class RemoveLatitudeFromUser < ActiveRecord::Migration
  def change
    remove_column :users, :latitude, :float
  end
end
