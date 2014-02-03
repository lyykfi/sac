class Subject < ActiveRecord::Base
	include XlsCsvImport

  attr_accessible :name, :short_name, :country_id, :district_id
	has_many :param_presets
	has_many :param_vals
	has_many :param_levels
	has_many :param_subjects
	has_many :events

	scope :countries, where("country_id is NULL AND district_id is NULL")
	scope :districts, where("country_id is not NULL AND district_id is NULL")
	scope :regions, where("country_id is not NULL AND district_id is not NULL")

	def is_country?
		self.country_id.nil?
	end

	def is_district?
		!self.country_id.nil? && self.district_id.nil?
	end

	def is_region?
		!self.country_id.nil? && !self.district_id.nil?
	end

	def parent
		parent_id = self.district_id || self.country_id || nil
		Subject.find(parent_id)
	end

	def children
		if self.is_country?
			Subject.where(['country_id = ? AND district_id is NULL', self.id])
		elsif self.is_district?
			Subject.where(['district_id = ?', self.id])
		else
			[]
		end
	end

	def subtree
		Subject.where(['country_id = ? OR district_id = ?', self.id, self.id])
	end
end