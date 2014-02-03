class UomDecorator < Draper::Decorator
  delegate_all

  include Draper::CanCan

  def name
    source.name || "---"
  end
end

class UomsDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages, to: :source
  include Draper::CanCan
end