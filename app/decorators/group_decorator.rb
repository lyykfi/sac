class GroupDecorator < Draper::Decorator
	delegate_all

	def position
		source.position ? source.position : "---"
	end
end

class GroupsDecorator < Draper::CollectionDecorator
	delegate :current_page, :per_page, :offset, :total_entries, :total_pages, to: :source
end