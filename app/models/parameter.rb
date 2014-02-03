class Parameter < ActiveRecord::Base
  # include XlsCsvImport

  # acts_as_paranoid column: 'deleted_at', column_type: 'time'
  attr_accessible :group_id, :formula_id, :name, :short_name, :position, :uom_id

  has_many :param_presets, dependent: :delete_all
  has_many :param_vals, dependent: :delete_all
  has_many :param_levels, dependent: :delete_all
  # #has_many :param_subjects, dependent: :delete_all
  has_many :subjects, through: :param_subjects
  has_many :param_refs, dependent: :delete_all

  belongs_to :group
  belongs_to :uom
  belongs_to :formula

  scope :of_group, lambda {|group| {conditions: {group_id: group.id}}}
  scope :in_group_ids, lambda {|ids| where(['group_id IN (?)', ids])}
  scope :not_in_group_ids, lambda {|ids| where(['group_id NOT IN (?)', ids])}

  scope :of_uom, lambda {|uom| {conditions: {uom_id: uom.id}}}
  scope :in_uom_ids, lambda {|ids| where(['uom_id IN (?)', ids])}
  scope :not_in_uom_ids, lambda {|ids| where(['uom_id NOT IN (?)', ids])}

  scope :with_formula, lambda {|formula| {conditions: {formula_id: formula.id}}}
  scope :in_formula_ids, lambda {|ids| where(['formula_id IN (?)', ids])}
  scope :not_in_formula_ids, lambda {|ids| where(['formula_id NOT IN (?)', ids])}

  def self.is_restricted?(current_user, field)
    restricted_fields = { operator: [:id], moderator: [:id], administrator: [:id] }
    restricted_fields[current_user.role.name.to_sym].include?(field) if restricted_fields.keys.include?(current_user.role.name.to_sym)
  end

  def self.vals_by_id_and_year(id, year)
    Parameter.joins(:param_vals
      ).where(
        'parameters.id = ? AND YEAR(param_vals.date_time) = ?', id, year
      ).select('param_vals.subject_id, param_vals.val_numeric')
  end

  def self.names_by_subject_ids_and_year(subject_ids, year)
    Parameter.joins(:group, :param_vals
      ).where(
        'param_vals.subject_id IN (?) AND YEAR(param_vals.date_time) = ?', subject_ids, year
      ).select('parameters.group_id, groups.name as group_name, parameters.id, parameters.name').order('parameters.group_id, parameters.id').uniq
  end

  def self.uom_name_by_id(id)
    Parameter.joins(:uom
      ).where(
        'parameters.id = ?', id
      ).pluck('uoms.name').first
  end
end