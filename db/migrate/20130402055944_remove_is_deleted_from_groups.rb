class RemoveIsDeletedFromGroups < ActiveRecord::Migration
  def up
    remove_column :groups, :is_deleted
    remove_column :parameters, :is_deleted
  end

  def down
    add_column :groups, :is_deleted, :boolean, default: false
    add_column :parameters, :is_deleted, :boolean, default: false
  end
end
