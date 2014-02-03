class ActiveRecord::Relation
	def ids
		ids = []
		self.each {|e| ids << e.id}
		ids
	end
end