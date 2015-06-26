class CreateLoginUsers < ActiveRecord::Migration
  def change
    create_table :login_users do |t|
      t.string :name
      t.string :email
      t.string :token

      t.timestamps null: false
    end
  end
end
