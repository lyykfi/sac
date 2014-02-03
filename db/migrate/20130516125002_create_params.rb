class CreateParams < ActiveRecord::Migration
  def change
    create_table :params do |t|
      t.string :name,     :null => false
      t.integer :level,   :null => false
      t.references :uom

      t.timestamps
    end
    add_index :params, :uom_id
  end
end
