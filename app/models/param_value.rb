class ParamValue < ActiveRecord::Base
  belongs_to :param
  belongs_to :subject

  attr_accessible :color, :val_numeric, :year

  def self.vals_by_param_id_and_year(param_id, year)
    ParamValue.where(
        'param_id = ? AND year = ?', param_id, year
      ).select(
        'subject_id, param_id, val_numeric, color'
      ).order('subject_id')
  end

  def self.show_map(param_id, year, part)
    cache_filename = "#{param_id}_#{year}_#{part}.jpg"
    cache_filename_full = "#{Rails.application.config.color_map_cache_path}#{cache_filename}"
    cache_filename_url = "#{Rails.application.config.color_map_cache_url}#{cache_filename}"
    if FileTest.exist?(cache_filename_full) &&
       (Time.now - File.mtime(cache_filename_full)) / 60 < 5
      cache_filename_url
    else
      ParamValue.make_color_map(param_id, year, part)
    end
  end

private

  def self.map_filenames(param_id, year, part)
    color_map_path = Rails.application.config.color_map_root_path + '_3/'
    result = []

    ParamValue.joins(:subject
      ).where(
        "param_id = ? AND year = ? AND LENGTH(subjects.map_basefilename_#{part}) > 4", param_id, year
      ).select(
        "color, subjects.map_basefilename_#{part} as filename"
      ).each { |el| result << "#{color_map_path}#{el.color}/#{el.filename}.png" }

    result.join(' ')
  end

  def self.make_color_map(param_id, year, part)
    cache_filename = "#{param_id}_#{year}_#{part}.jpg"
    cache_filename_full = "#{Rails.application.config.color_map_cache_path}#{cache_filename}"
    cache_filename_url = "#{Rails.application.config.color_map_cache_url}#{cache_filename}"
    blank_map_filename = "#{Rails.application.config.color_map_root_path}blank_map_#{part}.jpg"

    maps = ParamValue.map_filenames(param_id, year, part)

    if !maps.blank? && system("gm time convert -size 1920x1080 -compose over #{blank_map_filename} #{maps} -mosaic #{cache_filename_full}")
      cache_filename_url
    elsif maps.blank?
      'add values or maps for region'
    else
      'error'
    end
  end
end
