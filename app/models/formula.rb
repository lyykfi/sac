class Formula < ActiveRecord::Base
	include XlsCsvImport

  acts_as_paranoid column: 'deleted_at', column_type: 'time'
	attr_accessible :id, :name
	has_many :parameters, dependent: :delete_all

  def self.is_restricted?(current_user, field)
    restricted_fields = { operator: [:id, :name], moderator: [:id], administrator: [:id, :name] }
    restricted_fields[current_user.role.name.to_sym].include?(field) if restricted_fields.keys.include?(current_user.role.name.to_sym)
  end

  def self.to_csv_xls(type)
    options = {}
    options[:col_sep] = "\t" if type == :xls
    result = CSV.generate(options) do |csv|
      csv << column_names
      all.each do |item|
        csv << item.attributes.values_at(*column_names)
      end
    end
    result.encode(Encoding::CP1251, undef: :replace)
  end
end