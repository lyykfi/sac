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
    self.role_id && self.role_id.to_i > 0
  end
  def is_admin?
    self.role.name == 'administrator' if self.has_role?
  end
  def is_operator?
    self.role.name == 'operator' if self.has_role?
  end
  def is_analyst?
    self.role.name == 'analyst' if self.has_role?
  end
  def is_director?
    self.role.name == 'director' if self.has_role?
  end
end
