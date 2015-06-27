class AddLongitudeToLoginUser < ActiveRecord::Migration
  def change
    add_column :login_users, :longitude, :float
  end
end
