class Param < ActiveRecord::Base
  belongs_to :uom

  has_many :param_vals

  attr_accessible :level, :name

  def self.names_by_level(level)
    Param.joins('LEFT OUTER JOIN uoms ON uoms.id = params.uom_id'
      ).where(
        'params.level IN (?)', level
      ).select('params.id, params.name, uoms.name as uom_name').order('params.id')
  end
end
