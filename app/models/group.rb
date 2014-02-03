#encoding: utf-8

class Group < ActiveRecord::Base
  include XlsCsvImport

  acts_as_paranoid column: 'deleted_at', column_type: 'time'
  has_many :parameters, dependent: :delete_all

  attr_accessible :id, :name, :position, :short_name

  validates :position, numericality: true, allow_nil: true, allow_blank: true

  def self.is_restricted?(current_user, field)
    restricted_fields = { operator: [:id], moderator: [:id], administrator: [:id] }
    restricted_fields[current_user.role.name.to_sym].include?(field) if restricted_fields.keys.include?(current_user.role.name.to_sym)
  end

  def self.by_subject_and_year( subject_id, year )
    result = []
    subject_ids = Subject.children_ids(subject_id)

    Group.includes(:parameters => :param_vals).where('param_vals.subject_id in (?) AND YEAR(param_vals.date_time) = ?', subject_ids, year).each do |g|
      g.parameters.each do |p|
        item = {}
        item['group_id'] = g.id
        item['group_name'] = g.name
        item['group_short_name'] = g.short_name
        item['param_id'] = p.id
        item['param_name'] = p.name
        item['param_short_name'] = p.short_name
        item['param_val'] = p.param_vals.detect {|el| el.try(:subject_id).to_s == subject_id.to_s}.try(:val_numeric)

        result << item
      end
    end
    result
  end

end
