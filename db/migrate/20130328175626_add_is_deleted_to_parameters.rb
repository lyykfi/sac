class AddIsDeletedToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :is_deleted, :boolean, default: false
  end
end
