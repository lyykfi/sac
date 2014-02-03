#encoding: utf-8

class ParamLevelGrid < Netzke::Basepack::Grid
  def configure(c)
    super
    c.model = "ParamLevel"
    c.title = "Уровни параметров"
    c.columns = [
      {name: :subject__name, text: "Субъект", flex: 1},
      {name: :parameter__name, text: "Параметер", flex: 1},
      {name: :down_level, text: "Нижний"},
      {name: :up_level, text: "Верхний"},
      {name: :color, text: "Цвет"}]
  end
end