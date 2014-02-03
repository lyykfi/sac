#encoding: utf-8

class Group < ActiveRecord::Base
	include XlsCsvImport

  attr_accessible :id, :name, :position, :short_name, :is_deleted
	has_many :parameters

	validates :position, numericality: true, allow_nil: true, allow_blank: true

	before_destroy :safe_delete

	def safe_delete
		deletable? ? mark_as_deleted : false
	end

	private

		def mark_as_deleted
			self.parameters.each do |p|
				p.is_deleted = true
				p.save
			end
			self.is_deleted = true
			false
		end

		def deletable?
			self.parameters.any?
		end
end
