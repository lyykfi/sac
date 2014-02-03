class User < ActiveRecord::Base
  belongs_to :role

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  #  :recoverable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :lockable,
          :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :login, :name, :email, :password, :password_confirmation, :remember_me, :locked_at, :role_id
  # attr_accessible :title, :body

  # Check user on role
  def has_role?
    Role.roles.include? role.try(:name)
  end

  def is_admin?
    role.try(:name) == 'administrator'
  end

  def is_operator?
    role.try(:name) == 'operator'
  end

  def is_moderator?
    role.try(:name) == 'moderator'
  end

  def is_visitor?
    role.try(:name) == 'visitor'
  end
end
