class ParamRef < ActiveRecord::Base
	include XlsCsvImport

	attr_accessible :id, :parameter_id, :child_parameter_id, :position
	belongs_to :parameter

	scope :of_parameter, lambda {|parameter| {conditions: {parameter_id: parameter.id}}}
	scope :in_parameter_ids, lambda {|ids| where(['parameter_id IN (?)', ids])}
	scope :not_in_parameter_ids, lambda {|ids| where(['parameter_id NOT IN (?)', ids])}
end