class Event < ActiveRecord::Base
	include XlsCsvImport

	attr_accessible :id, :name, :parameter_id, :subject_id, :event_status_id, :date_time
	belongs_to :event_status
	belongs_to :subject
	belongs_to :parameter

	scope :of_parameter, lambda { |parameter| { conditions: {parameter_id: parameter.id} } }
	scope :in_parameter_ids, lambda {|ids| where(['parameter_id IN (?)', ids])}
	scope :not_in_parameter_ids, lambda {|ids| where(['parameter_id NOT IN (?)', ids])}

	scope :of_subject, lambda { |subject| { conditions: {subject_id: subject.id} } }
	scope :in_subject_ids, lambda {|ids| where(['subject_id IN (?)', ids])}
	scope :not_in_subject_ids, lambda {|ids| where(['subject_id NOT IN (?)', ids])}

	scope :of_event_status, lambda { |event_status| { conditions: {event_status_id: event_status.id} } }
	scope :in_event_status_ids, lambda {|ids| where(['event_status_id IN (?)', ids])}
	scope :not_in_event_status_ids, lambda {|ids| where(['event_status_id NOT IN (?)', ids])}
end