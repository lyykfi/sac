class CreateFormulas < ActiveRecord::Migration
	def change
		create_table :formulas do |t|
			t.text :name

			t.timestamps
		end
	end
end
