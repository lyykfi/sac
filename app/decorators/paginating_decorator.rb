class PaginatingDecorator < Draper::CollectionDecorator
	delegate :current_page, :per_page, :offset, :total_entries, :total_pages, to: :source

	include Draper::CanCan
end