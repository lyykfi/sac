class CreateParamSubjects < ActiveRecord::Migration
  def change
		create_table :param_subjects do |t|
			t.integer :parameter_id
			t.integer :subject_id

			t.timestamps
		end
  end
end
