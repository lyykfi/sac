class AddDeletedAtToParameters < ActiveRecord::Migration
  def change
    add_column :parameters, :deleted_at, :datetime
  end
end
