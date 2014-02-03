# encoding: utf-8

class ParamVal < ActiveRecord::Base
	include XlsCsvImport

  attr_accessible :parameter_id, :subject_id, :val_numeric, :val_string, :date_time
	belongs_to :parameter
	belongs_to :subject

	scope :of_parameter, lambda { |parameter| { conditions: {parameter_id: parameter.id} } }
	scope :in_parameter_ids, lambda {|ids| where(['parameter_id IN (?)', ids])}
	scope :not_in_parameter_ids, lambda {|ids| where(['parameter_id NOT IN (?)', ids])}

	scope :of_year, lambda { |year| where("YEAR(date_time) = ?", year) }
	scope :less_than_or_equal_to_date, lambda { |date| where("date_time <= ?", Time.new(date)) }
	scope :grater_than_or_equal_to_date, lambda { |date| where("date_time >= ?", Time.parse(date)) }
	scope :between_dates, lambda { |start_date, end_date| where("date_time BETWEEN '#{Time.parse(start_date)}' AND '#{Time.parse(end_date)}'") }

	scope :of_subject, lambda { |subject| { conditions: {subject_id: subject.id} } }
	scope :in_subject_ids, lambda {|ids| where(['subject_id IN (?)', ids])}
	scope :not_in_subject_ids, lambda {|ids| where(['subject_id NOT IN (?)', ids])}

	# get parameter values of all parameters of given group
	def self.of_group(group_id)
		group = Group.find(group_id)
		param_ids = Parameter.of_group(group).pluck(:id)
		return ParamVal.in_parameter_ids(param_ids)
	end

	# get parameter values of given subject with its children
	def self.of_subject_with_children(subject_id)
		subject = Subject.find(subject_id)
		subject_children_ids = subject.children.ids
		subject_children_ids << subject.id
		ParamVal.in_subject_ids(subject_children_ids)
	end

	def self.available_years
		years = ParamVal.pluck(:date_time).map{|x| x.year}.uniq
	end

	def self.get_cube(year=nil)
		years = year || available_years
		layers = {}
		years.each {|y| layers[y] = ParamVal.of_year(y).select('id, parameter_id, subject_id, val_numeric, val_string, date_time')}
		layers
	end
	
	
	
	def self.attr_sortable
    [:val_numeric, :subject_id, :date_time]
  end
  
  def self.attr_visible
    [[:parameter_id, "Номер параметра"],
     [:subject_id, "Субъект"],
     [:val_numeric, "Значение, цифр."],
     [:val_string, "Значение"],
     [:date_time, "Дата"]]
  end
  
end
