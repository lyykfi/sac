class ParamSubject < ActiveRecord::Base
	include XlsCsvImport

	attr_accessible :id, :name, :subject_id
	belongs_to :parameter
	belongs_to :subject

	scope :of_parameter, lambda { |parameter| { conditions: {parameter_id: parameter.id} } }
	scope :in_parameter_ids, lambda {|ids| where(['parameter_id IN (?)', ids])}
	scope :not_in_parameter_ids, lambda {|ids| where(['parameter_id NOT IN (?)', ids])}

	scope :of_subject, lambda { |subject| { conditions: {subject_id: subject.id} } }
	scope :in_subject_ids, lambda {|ids| where(['subject_id IN (?)', ids])}
	scope :not_in_subject_ids, lambda {|ids| where(['subject_id NOT IN (?)', ids])}
end