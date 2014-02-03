#encoding: utf-8

module ApplicationHelper

	def side_menu_items
		items = [
				{name: 'groups',          url: url_for(controller: 'groups'),         caption: 'Группы параметров'},
				#{name: 'formulas',        url: url_for(controller: 'formulas'),       caption: 'Формулы'},
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

    arrow_class = 'icon-chevron-up' if direction == 'desc'
    arrow_class = 'icon-chevron-down' if direction == 'asc'
    arrow_class = 'icon-nbsp' if css_class.nil?
    (link_to title, params.merge(:sort => column, :direction => direction, :page => nil), {:class => css_class})+(content_tag :i, nil, class: arrow_class)
  end

  def is_accessible?(field, role)
    clazz = field.split('.')[0]
    method = field.split('.')[1]

    !clazz.classify.constantize.restricted_fields[role].include?(method)
  end
end
