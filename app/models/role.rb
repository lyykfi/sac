class Role < ActiveRecord::Base
  has_many :users

  attr_accessible :name

  def self.roles
    %w(administrator moderator operator visitor)
  end
end