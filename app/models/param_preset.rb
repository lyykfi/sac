class ParamPreset < ActiveRecord::Base
	include XlsCsvImport

  acts_as_paranoid column: 'deleted_at', column_type: 'time'
  attr_accessible :down_preset, :parameter_id, :subject_id, :up_preset, :date_time
	belongs_to :subject
	belongs_to :parameter

	scope :of_parameter, lambda { |parameter| { conditions: {parameter_id: parameter.id} } }
	scope :in_parameter_ids, lambda {|ids| where(['parameter_id IN (?)', ids])}
	scope :not_in_parameter_ids, lambda {|ids| where(['parameter_id NOT IN (?)', ids])}

	scope :of_year, lambda { |year| where("YEAR(date_time) = ?", year) }
	scope :less_than_or_equal_to_date, lambda { |date| where("date_time <= ?", Time.new(date)) }
	scope :grater_than_or_equal_to_date, lambda { |date| where("date_time => ?", Time.new(date)) }

	scope :of_subject, lambda { |subject| { conditions: {subject_id: subject.id} } }
	scope :in_subject_ids, lambda {|ids| where(['subject_id IN (?)', ids])}
	scope :not_in_subject_ids, lambda {|ids| where(['subject_id NOT IN (?)', ids])}

  def self.is_restricted?(current_user, field)
    restricted_fields = { operator: [:id], moderator: [:id], administrator: [:id] }
    restricted_fields[current_user.role.name.to_sym].include?(field) if restricted_fields.keys.include?(current_user.role.name.to_sym)
  end
end
