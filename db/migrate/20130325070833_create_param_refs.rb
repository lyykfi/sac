class CreateParamRefs < ActiveRecord::Migration
  def change
		create_table :param_refs do |t|
			t.integer :parameter_id
			t.integer :child_parameter_id
			t.integer :position

			t.timestamps
		end
  end
end
