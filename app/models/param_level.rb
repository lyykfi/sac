class ParamLevel < ActiveRecord::Base
	include XlsCsvImport

  attr_accessible :parameter_id, :up_level, :down_level, :color, :subject_id
	belongs_to :parameter
	belongs_to :subject

	scope :of_parameter, lambda { |parameter| { conditions: {parameter_id: parameter.id} } }
	scope :in_parameter_ids, lambda {|ids| where(['parameter_id IN (?)', ids])}
	scope :not_in_parameter_ids, lambda {|ids| where(['parameter_id NOT IN (?)', ids])}

	scope :limits_color, lambda {|subject_id, parameter_id| {conditions: {subject_id: subject_id, parameter_id: parameter_id}}}
end
