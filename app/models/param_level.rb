class ParamLevel < ActiveRecord::Base
  include XlsCsvImport

  acts_as_paranoid column: 'deleted_at', column_type: 'time'
  attr_accessible :parameter_id, :up_level, :down_level, :color, :subject_id
  belongs_to :parameter
  belongs_to :subject

  scope :of_parameter, lambda { |parameter| { conditions: {parameter_id: parameter.id} } }
  scope :in_parameter_ids, lambda {|ids| where(['parameter_id IN (?)', ids])}
  scope :not_in_parameter_ids, lambda {|ids| where(['parameter_id NOT IN (?)', ids])}

  scope :limits_color, lambda {|subject_id, parameter_id| {conditions: {subject_id: subject_id, parameter_id: parameter_id}}}

  def self.is_restricted?(current_user, field)
    restricted_fields = { operator: [:id], moderator: [:id], administrator: [:id] }
    restricted_fields[current_user.role.name.to_sym].include?(field) if restricted_fields.keys.include?(current_user.role.name.to_sym)
  end

  def self.colors
    # %w(blue red yellow yellow green)
    # %w(blue #ff7f7f #ffbf7f #ffff7f #7fff7f)
    {
      '0' => 'blue',
      '#ff7f7f' => 'red',
      '#ffbf7f' => 'yellow',
      '#ffff7f' => 'yellow',
      '#7fff7f' => 'green'
    }
  end

  def self.by_param_id_and_subject_id(param_id, subject_id)
    ParamLevel.select([:color, :down_level, :up_level]).limits_color(subject_id, param_id).order(:color).inject(Hash.new{[]}) do |acc, el|
      color = ParamLevel.colors[el.color]
      if el.color == '#ffff7f'
        acc[color][0] = el.down_level
      else
        acc[color] = [el.down_level, el.up_level]
      end
      acc
    end
  end

end
