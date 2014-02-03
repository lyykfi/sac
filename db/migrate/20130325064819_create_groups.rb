class CreateGroups < ActiveRecord::Migration
	def change
		create_table :groups do |t|
			t.text :name
			t.string :short_name
			t.integer :position

			t.timestamps
		end
	end
end
