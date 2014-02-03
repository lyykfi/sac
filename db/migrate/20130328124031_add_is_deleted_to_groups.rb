class AddIsDeletedToGroups < ActiveRecord::Migration
  def change
    add_column :groups, :is_deleted, :boolean, default: false
  end
end
