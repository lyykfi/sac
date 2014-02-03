class AddDeletedAtToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :deleted_at, :datetime, null: true
    remove_column :groups, :is_deleted
  end
end
