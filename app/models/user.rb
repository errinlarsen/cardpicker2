class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :role, :password, :password_confirmation

  # Roles for authorization with cancan
  ROLES = %w[admin editor consumer]

  def admin?
    role == 'admin'
  end

  def editor?
    role == 'editor'
  end

  def guest?
    role.nil?
  end
end
