class Formula < ActiveRecord::Base
	include XlsCsvImport

	attr_accessible :id, :name
	has_many :parameters
	
	def self.attr_sortable
    [:id, :name]
  end
  
  def self.attr_visible
    [[:id, "ID"],
     [:name, "Name"]]
  end
	
end