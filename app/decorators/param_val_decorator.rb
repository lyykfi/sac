class ParamValDecorator < Draper::Decorator
  delegate_all

  include Draper::CanCan

  def val_numeric
    source.val_numeric || "---"
  end

  def val_string
    source.val_string || "---"
  end

  def date_time
    source.date_time.strftime("%d/%m/%Y") || "---"
  end

  def parameter
    source.parameter.short_name || "---"
  end

  def subject
    source.subject.short_name || "---"
  end
end

class ParamValsDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages, to: :source
  include Draper::CanCan
end