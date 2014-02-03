class Parameter < ActiveRecord::Base
	include XlsCsvImport

  attr_accessible :group_id, :formula_id, :name, :short_name, :position, :uom_id
  has_many :param_presets
  has_many :param_vals
	has_many :param_levels
	has_many :param_subjects
	has_many :param_refs

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
end