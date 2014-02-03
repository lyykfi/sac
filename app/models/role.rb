class Role < ActiveRecord::Base
  has_many :users
  
  attr_accessible :name
  
  # administrator - администратор
  # operator - оператор
  # analyst - аналитик
  # director - руководитель  
end