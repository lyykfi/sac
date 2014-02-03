#encoding: utf-8

class ParamValGrid < Netzke::Basepack::Grid
  def configure(c)
    super
    c.model = "ParamVal"
    c.title = "Значения параметров"
    c.columns = [
      {name: :subject__name, text: "Субъект", flex: 1},
      {name: :parameter__name, text: "Название", flex: 1},
      {name: :val_numeric, text: "Значение"}]
  end
end