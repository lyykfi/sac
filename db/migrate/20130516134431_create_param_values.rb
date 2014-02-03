class CreateParamValues < ActiveRecord::Migration
  def change
    create_table :param_values do |t|
      t.float :val_numeric, :default => 0,      :null => false
      t.string :color,      :default => "blue", :null => false
      t.integer :year,      :default => 2012,   :null => false
      t.references :param
      t.references :subject

      t.timestamps
    end
    add_index :param_values, :param_id
    add_index :param_values, :subject_id
  end
end
