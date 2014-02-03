class EventStatus < ActiveRecord::Base
	include XlsCsvImport

	attr_accessible :id, :name

	has_many :events
end