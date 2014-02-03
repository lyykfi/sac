class Subject < ActiveRecord::Base
  include XlsCsvImport

  attr_accessible :name, :short_name, :country_id, :district_id, :region_id,
                  :map_basefilename,
                  :map_basefilename_west, :map_basefilename_central, :map_basefilename_east
  has_many :param_presets
  has_many :param_vals
  has_many :param_levels
  #has_many :param_subjects
  has_many :parameters, through: :param_subjects
  has_many :events

  scope :countries, where("country_id is NULL AND district_id is NULL")
  scope :districts, where("country_id is not NULL AND district_id is NULL")
  scope :regions, where("country_id is not NULL AND district_id is not NULL")
  scope :municipals, where("country_id is not NULL AND district_id is not NULL AND region_id is not NULL")

  def is_country?
    self.country_id.nil?
  end

  def is_district?
    !self.country_id.nil? && self.district_id.nil?
  end

  def is_region?
    !self.country_id.nil? && !self.district_id.nil? && self.region_id.nil?
  end

  def is_municipal?
    !self.country_id.nil? && !self.district_id.nil? && !self.region_id.nil?
  end

  def parent
    Subject.find(parent_id) unless parent_id.blank?
  end

  def children
    if self.is_country?
      Subject.where(['country_id = ? AND district_id is NULL', self.id])
    elsif self.is_district?
      Subject.where(['district_id = ? AND region_id is NULL', self.id])
    elsif self.is_region?
      Subject.where(['region_id = ?', self.id])
    else
      []
    end
  end

  def self.children_ids(subject_id)
    s = Subject.find(subject_id)
    s.children.inject([subject_id]){|acc,e| acc << e.id}
  end

  def subtree
    Subject.where(['country_id = ? OR district_id = ? AND region_id is NULL', self.id, self.id])
  end

  def self.show_color_map(param_id, parent_subject_id, year)
    cache_filename = "#{param_id}_#{parent_subject_id}_#{year}.jpg"
    cache_filename_full = "#{Rails.application.config.color_map_cache_path}#{cache_filename}"
    cache_filename_url = "#{Rails.application.config.color_map_cache_url}#{cache_filename}"

    if FileTest.exist?(cache_filename_full) &&
       (Time.now - File.mtime(cache_filename_full)) / 60 < 5
      cache_filename_url
    else
      ParamVal.make_color_map(param_id, parent_subject_id, year)
    end
  end

private

  def parent_id
    self.region_id || self.district_id || self.country_id || nil
  end

end
