class ActiveRecord::Relation
	def ids
		ids = []
		self.each {|e| ids << e.id}
		ids
  end
end

class ActiveRecord::Base
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

  def self.sort_by(args)
    if args[:association]
      joins(args[:association]).order("#{args[:association].to_s.tableize}.#{args[:field]} #{args[:sort_direction].to_s}")
    else
      order("#{args[:association].to_s.tableize}.#{args[:field]} #{args[:sort_direction].to_s}")
    end
  end

  def self.filtered_by(args)
    conditions = ""
    entities = []
    args[:associations].each do |assc|
      conditions += "CAST(#{assc[:name].to_s.tableize}.#{assc[:field]} AS CHAR) LIKE '%#{args[:search_condition]}%'"
      conditions += " OR " unless assc == args[:associations].last
      entities << assc[:name] unless assc[:name].to_s.classify == self.first.class.to_s
    end
    joins(entities).where(conditions)
  end
end