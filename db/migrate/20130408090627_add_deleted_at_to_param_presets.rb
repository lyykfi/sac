class AddDeletedAtToParamPresets < ActiveRecord::Migration
  def change
    add_column :param_presets, :deleted_at, :datetime
  end
end
