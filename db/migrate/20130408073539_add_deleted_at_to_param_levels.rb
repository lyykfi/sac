class AddDeletedAtToParamLevels < ActiveRecord::Migration
  def change
    add_column :param_levels, :deleted_at, :datetime
  end
end
