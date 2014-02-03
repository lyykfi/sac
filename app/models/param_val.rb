# encoding: utf-8

class ParamVal < ActiveRecord::Base
  include XlsCsvImport

  acts_as_paranoid column: 'deleted_at', column_type: 'time'
  attr_accessible :parameter_id, :subject_id, :val_numeric, :val_string, :date_time

  belongs_to :parameter
  belongs_to :subject

  scope :of_parameter, lambda { |parameter| { conditions: {parameter_id: parameter.id} } }
  scope :in_parameter_ids, lambda {|ids| where(['parameter_id IN (?)', ids])}
  scope :not_in_parameter_ids, lambda {|ids| where(['parameter_id NOT IN (?)', ids])}

  scope :of_year, lambda { |year| where("YEAR(date_time) = ?", year) }
  scope :less_or_equal_year, lambda { |year| where("YEAR(date_time) <= ?", year) }
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
    ParamVal.pluck(:date_time).map{|x| x.year}.uniq
  end

  def self.get_cube(year=nil)
    years = year || available_years
    layers = {}
    years.each {|y| layers[y] = ParamVal.of_year(y).select('id, parameter_id, subject_id, val_numeric, val_string, date_time')}
    layers
  end

  def self.is_restricted?(current_user, field)
    restricted_fields = { operator: [:id], moderator: [:id], administrator: [:id] }
    restricted_fields[current_user.role.name.to_sym].include?(field) if restricted_fields.keys.include?(current_user.role.name.to_sym)
  end

  def self.by_param_id_and_subjects_with_children_and_year(param_id, parent_subject_id, year)
    ParamVal.in_parameter_ids(param_id).in_subject_ids(Subject.find(parent_subject_id).children).of_year(year).inject(Hash.new{nil}) do |acc, el|
        acc[el.subject_id] = el.val_numeric
        acc
    end
  end

  def self.map_filenames(param_id, parent_subject_id, year)
    color_map_path = Rails.application.config.color_map_root_path
    result = []

    vals = ParamVal.by_param_id_and_subjects_with_children_and_year(param_id, parent_subject_id, year)
    colors = ParamLevel.limits_color(parent_subject_id, param_id)

    Subject.find(parent_subject_id).children.each do |el|
      result << [
              el.map_basefilename,
              colors.select do |c|
                param_val = vals[el.id].to_f
                c.down_level.to_f <= param_val and param_val <= c.up_level.to_f
              end.first.try(:color)
             ] unless el.map_basefilename.blank?
    end
    #result
    result.map { |e| [e[0], e[1].blank? ? e[1] = ParamLevel.colors['0'] : e[1] = ParamLevel.colors[e[1]]] }.map { |e| color_map_path + "#{e[1]}/#{e[0]}.png" }.join(' ')
  end

  def self.make_color_map(param_id, parent_subject_id, year)
    cache_filename = "#{param_id}_#{parent_subject_id}_#{year}.jpg"
    cache_filename_full = "#{Rails.application.config.color_map_cache_path}#{cache_filename}"
    cache_filename_url = "#{Rails.application.config.color_map_cache_url}#{cache_filename}"
    blank_map_filename = "#{Rails.application.config.map_root_path}#{parent_subject_id}.png"

    maps = ParamVal.map_filenames(param_id, parent_subject_id, year)

    if !maps.blank? && system("gm time convert -size 1920x1080 -compose over #{blank_map_filename} #{maps} -mosaic #{cache_filename_full}")
      cache_filename_url
    elsif maps.blank?
      'add values or maps for region'
    else
      'error'
    end
  end

  def self.table_by_subject_ids_and_parameter_ids_and_year(subject_ids, parameter_ids, year)
    ParamVal.in_subject_ids(subject_ids).in_parameter_ids(parameter_ids).of_year(year).joins(
        :subject, :parameter
      ).select(
        'subjects.name as subject_name, parameters.name as parameter_name, val_numeric, YEAR(date_time) as year'
      ).order('subjects.name, parameters.name')
  end

  def self.chart_by_subject_ids_and_parameter_ids_and_years( subject_ids, parameter_ids, year1, year2 )
    result = {}
    ParamVal.in_subject_ids(subject_ids).in_parameter_ids(parameter_ids).between_dates("#{year1}-01-01", "#{year2}-12-31").joins(
        :subject, :parameter
      ).select(
        'parameter_id, parameters.name as parameter_name, subject_id, subjects.name as subject_name, val_numeric, EXTRACT(YEAR_MONTH FROM date_time) as date'
      ).order('parameter_id, subject_id, date_time'
      ).each do |v|
        result[v.parameter_id] = {} unless result.key? v.parameter_id

          result[v.parameter_id][:param_name] = v.parameter_name unless result[v.parameter_id].key? :param_name
          result[v.parameter_id][:subjects] = {}                 unless result[v.parameter_id].key? :subjects

            result[v.parameter_id][:subjects][v.subject_id] = {}   unless result[v.parameter_id][:subjects].key? v.subject_id

              result[v.parameter_id][:subjects][v.subject_id][:subject_name] = v.subject_name unless result[v.parameter_id][:subjects][v.subject_id].key? :subject_name
              result[v.parameter_id][:subjects][v.subject_id][:vals_numeric] = {}             unless result[v.parameter_id][:subjects][v.subject_id].key? :vals_numeric

                result[v.parameter_id][:subjects][v.subject_id][:vals_numeric][v.date] = v.val_numeric
      end
    result
  end
end
