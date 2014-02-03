module XlsCsvImport
	def self.included(base)
		base.extend(ClassMethods)
	end

	module ClassMethods
		def import(file)
			spreadsheet = open_spreadsheet(file)
			header = spreadsheet.row(1)
			(2..spreadsheet.last_row).each do |i|
				row = Hash[[header, spreadsheet.row(i)].transpose]
				entity = find_by_id(row["id"]) || new
				entity.attributes = row.to_hash.slice(*accessible_attributes)
				entity.save!
			end
		end

		def open_spreadsheet(file)
			case File.extname(file.original_filename)
				when '.csv' then Roo::Csv.new(file.path, nil, :ignore)
				when '.xls' then Roo::Excel.new(file.path, nil, :ignore)
				when '.xlsx' then Roo::Excelx.new(file.path, nil, :ignore)
				else raise "Unknown file type: #{file.original_filename}"
			end
		end
	end
end