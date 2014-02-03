class AddDeletedAtToParamVals < ActiveRecord::Migration
  def change
    add_column :param_vals, :deleted_at, :datetime
  end
end
