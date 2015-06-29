class CreateLoginUsers < ActiveRecord::Migration
  def change
    create_table :login_users do |t|
      t.string :token
    end
  end
end