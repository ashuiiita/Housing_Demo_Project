class CreateUsers < ActiveRecord::Migration
	def change 
		create_table "users", force: :cascade do |t|
		    t.string   "name"
		    t.string   "email"
		    t.string   "password"
		    t.datetime "created_at", null: false
		    t.datetime "updated_at", null: false
		    t.string   "phone"
		end
	end
end
