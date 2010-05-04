class CardSet < ActiveRecord::Base
  has_many :memberships
  has_many :cards, :through => :memberships

  accepts_nested_attributes_for :memberships, :cards

  validates_uniqueness_of :name
  validates_presence_of :name, :set_type
end
