class RemoveLongitudeFromLoginUser < ActiveRecord::Migration
  def change
    remove_column :login_users, :longitude, :float
  end
end
