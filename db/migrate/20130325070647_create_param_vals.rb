class CreateParamVals < ActiveRecord::Migration
  def change
		create_table :param_vals do |t|
			t.integer :parameter_id
			t.integer :subject_id
			t.datetime :date_time
			t.float :val_numeric
			t.float :val_string

			t.timestamps
		end
  end
end
