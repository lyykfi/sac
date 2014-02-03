class Uom < ActiveRecord::Base
  include XlsCsvImport

  acts_as_paranoid column: 'deleted_at', column_type: 'time'
  attr_accessible :name
  has_many :parameters

  def self.is_restricted?(current_user, field)
    restricted_fields = { operator: [:id], moderator: [:id], administrator: [:id] }
    restricted_fields[current_user.role.name.to_sym].include?(field) if restricted_fields.keys.include?(current_user.role.name.to_sym)
  end
end
