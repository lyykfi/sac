class AddDeletedAtToUoms < ActiveRecord::Migration
  def change
    add_column :uoms, :deleted_at, :datetime
  end
end
