class CreateParamPresets < ActiveRecord::Migration
  def change
		create_table :param_presets do |t|
			t.integer :parameter_id
			t.integer :subject_id
			t.datetime :date_time
			t.float :down_preset
			t.float :up_preset

			t.timestamps
		end
  end
end
