class AddLatitudeToLoginUser < ActiveRecord::Migration
  def change
    add_column :login_users, :latitude, :float
  end
end
