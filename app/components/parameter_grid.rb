#encoding: utf-8

class ParameterGrid < Netzke::Basepack::Grid
  def configure(c)
    super
    c.model = "Parameter"
    c.title = "Параметры"
    c.columns = [
      {name: :group__name, text: "Группа", flex: 1},
      {name: :name, text: "Название", flex: 1},
      {name: :uom__name, text: "uom", flex: 1}]
  end
end