class AddMapBasefilenameToSubjects < ActiveRecord::Migration
  def change
    add_column :subjects, :map_basefilename, :string
  end
end
