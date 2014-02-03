class FormulaDecorator < Draper::Decorator
  delegate_all

  include Draper::CanCan

  def name
    source.name ? source.name : "---"
  end
end

class FormulasDecorator < Draper::CollectionDecorator
  delegate :current_page, :per_page, :offset, :total_entries, :total_pages, to: :source
  include Draper::CanCan
end