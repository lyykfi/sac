class ParameterDecorator < Draper::Decorator
  delegate_all

  include Draper::CanCan

  def position
    source.position || "---"
  end

  def name
    source.name || "---"
  end

  def short_name
    source.short_name || "---"
  end

  def group
    source.group.short_name || source.group.name || "---"
  end

  def formula
    source.formula.name || "---"
  end

  def uom
    source.uom.name || "---"
  end
end

class ParametersDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages, to: :source
  include Draper::CanCan
end