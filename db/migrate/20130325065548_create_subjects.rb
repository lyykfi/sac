class CreateSubjects < ActiveRecord::Migration
  def change
		create_table :subjects do |t|
			t.integer :country_id
			t.integer :district_id
			t.text :name
			t.string :short_name

			t.timestamps
		end
  end
end
