#encoding: utf-8

module ApplicationHelper


	def side_menu_items
		items = [
				{name: 'groups',          url: url_for(controller: 'groups'),         caption: 'Группы параметров'},
				{name: 'formulas',        url: url_for(controller: 'formulas'),       caption: 'Формулы'},
				{name: 'parameters',      url: url_for(controller: 'parameters'),     caption: 'Параметры'},
				{name: 'param_vals',      url: url_for(controller: 'param_vals'),     caption: 'Значения параметров'},
				{name: 'param_levels',    url: url_for(controller: 'param_levels'),   caption: 'Уровни параметров'},
				{name: 'param_presets',   url: url_for(controller: 'param_presets'),  caption: 'Уставки'},
				{name: 'events',          url: url_for(controller: 'events'),         caption: 'События'},
				{name: 'event_statuses',  url: url_for(controller: 'event_statuses'), caption: 'Статусы событий'},
				{name: 'param_refs',      url: url_for(controller: 'param_refs'),     caption: 'Ссылки параметров'},
				{name: 'subjects',        url: url_for(controller: 'subjects'),       caption: 'Ссылки параметров'},
				{name: 'params_subjects', url: url_for(controller: 'param_subjects'), caption: 'Параметры по субъектам'},
				{name: 'uoms',            url: url_for(controller: 'uoms'),           caption: 'Единицы измерения'},
				#{name: 'users',           url: url_for(controller: 'users'),          caption: 'Пользователи'},
				#{name: 'roles',           url: url_for(controller: 'roles'),          caption: 'Роли'}
		]
	end

  def sortable(column, title = nil)
    title ||= column.titleize
    css_class = column == sort_column ? "current #{sort_direction}" : nil
    direction = column == sort_column && sort_direction == "asc" ? "desc" : "asc"
    link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class}
  end

#TODO Refactor!
#  def table_flexible(collection = {})
#    attr_sortable = collection.first.class.attr_sortable
#    attr_visible = collection.first.class.attr_visible
#
#    thead = content_tag :thead do
#      content_tag :tr do
#	      attr_visible << content_tag(:th, check_box_tag('check-header'))
#        attr_visible.collect {|column| concat content_tag(:th, attr_sortable.include?(column[0]) ? sortable(column[0].to_s, column[1]) : column[1])}.join().html_safe
#      end
#    end
#    tbody = content_tag :tbody do
#      collection.collect { |elem|
#        content_tag :tr do
#          attr_visible.collect { |column|
#              concat content_tag(:td, elem[column[0]])
#          }.to_s.html_safe
#        end
#      }.join().html_safe
#    end
#    content_tag :table, :class => "table table-striped table-bordered", :id => "table" do
#      thead.concat(tbody)
#    end
#  end
end
