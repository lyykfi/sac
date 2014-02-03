class CreateParamLevels < ActiveRecord::Migration
  def change
		create_table :param_levels do |t|
			t.integer :parameter_id
			t.integer :subject_id
			t.float :down_level
			t.float :up_level
			t.string :color

			t.timestamps
		end
  end
end
