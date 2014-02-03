class ParamPresetDecorator < Draper::Decorator
  delegate_all

  include Draper::CanCan

  def parameter
    source.parameter.short_name || source.parameter.name || "---"
  end

  def subject
    source.subject.short_name || source.subject.name || "---"
  end

  def down_preset
    source.down_preset || "---"
  end

  def up_preset
    source.up_preset || "---"
  end

  def date_time
    source.date_time || "---"
  end
end

class ParamPresetsDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages, to: :source
  include Draper::CanCan
end