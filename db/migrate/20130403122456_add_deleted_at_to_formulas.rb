class AddDeletedAtToFormulas < ActiveRecord::Migration
  def change
    add_column :formulas, :deleted_at, :datetime
  end
end
