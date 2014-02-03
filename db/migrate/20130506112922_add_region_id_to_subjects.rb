class AddRegionIdToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :region_id, :integer
  end
end
