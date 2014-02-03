class CreateParameters < ActiveRecord::Migration
  def change
		create_table :parameters do |t|
			t.integer :group_id
			t.integer :formula_id
			t.integer :uom_id
			t.text :name
			t.string :short_name
			t.integer :position

			t.timestamps
		end
  end
end
