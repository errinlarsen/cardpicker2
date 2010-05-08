class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :http_authenticatable, :token_authenticatable, :confirmable, :lockable, :timeoutable and :activatable
  devise :registerable, :database_authenticatable, :recoverable,
         :rememberable, :trackable, :validatable

  # Associations
  has_many :cards
  has_many :card_sets

  # Setup accessible (or protected) attributes for your model
  attr_accessible :username, :email, :role, :password, :password_confirmation

  # Validations for the new username column
  validates_presence_of :username
  validates_uniqueness_of :username
  validates_length_of :username, :minimum => 3
  validates_length_of :username, :maximum => 25

  # Roles for authorization with cancan
  ROLES = ['', 'admin', 'editor', 'consumer']

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
