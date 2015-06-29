class AddUserReferencesToLoginUser < ActiveRecord::Migration
  def change
    add_reference :login_users, :user, index: true, foreign_key: true
  end
end
