class GroupDecorator < Draper::Decorator
  delegate_all

  include Draper::CanCan

  def position
    source.position ? source.position : "---"
  end

  def name
    source.name ? source.name : "---"
  end

  def short_name
    source.short_name ? source.short_name : "---"
  end
end

class GroupsDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages, to: :source
  include Draper::CanCan
end