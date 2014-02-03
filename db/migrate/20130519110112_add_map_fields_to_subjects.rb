class AddMapFieldsToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :map_basefilename_west, :string
    add_column :subjects, :map_basefilename_central, :string
    add_column :subjects, :map_basefilename_east, :string
  end
end
