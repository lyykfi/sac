class TopTabPanel < Netzke::Base
  js_configure do |c|
    c.extend = "Ext.tab.Panel"
  end

  component :groups do |c|
    c.klass = GroupGrid
  end

  component :parameters do |c|
    c.klass = ParameterGrid
  end

  component :param_vals do |c|
    c.klass = ParamValGrid
  end

  component :param_levels do |c|
    c.klass = ParamLevelGrid
  end

  component :subjects do |c|
    c.klass = SubjectGrid
  end

  def configure(c)
    super
    c.items = [:groups, :parameters, :param_vals, :param_levels, :subjects]
  end
end
