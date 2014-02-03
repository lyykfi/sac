class Uom < ActiveRecord::Base
	include XlsCsvImport

  attr_accessible :name
	has_many :parameters
end
