class CreateEvents < ActiveRecord::Migration
  def change
		create_table :events do |t|
			t.integer :parameter_id
			t.integer :subject_id
			t.integer :event_status_id
			t.text :name
			t.string :short_name
			t.datetime :date_time

			t.timestamps
		end
  end
end
