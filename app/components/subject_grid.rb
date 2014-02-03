#encoding: utf-8

class SubjectGrid < Netzke::Basepack::Grid
  def configure(c)
    super
    c.model = "Subject"
    c.title = "Субъект"
    c.columns = [
      {name: :name, text: "Название", flex: 1},
      :country_id, :district_id, :region_id,
      :map_basefilename,
      :map_basefilename_west, :map_basefilename_central, :map_basefilename_east]
  end
end