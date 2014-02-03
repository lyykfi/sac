class ParamLevelDecorator < Draper::Decorator
  delegate_all

  include Draper::CanCan

  def parameter
    source.parameter.short_name || source.parameter.name || "---"
  end

  def subject
    source.subject.short_name || source.subject.name || "---"
  end

  def down_level
    source.down_level || "---"
  end

  def up_level
    source.up_level || "---"
  end

  def color
    source.color || "---"
  end

  def position
    source.position || "---"
  end
end

class ParamLevelsDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages, to: :source
  include Draper::CanCan
end