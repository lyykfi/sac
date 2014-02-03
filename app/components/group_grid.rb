#encoding: utf-8

class GroupGrid < Netzke::Basepack::Grid
  def configure(c)
    super
    c.model = "Group"
    c.title = "Группы параметров"
    c.columns = [{name: :name, text: "Название", flex: 1}]
  end
end