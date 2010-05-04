class Card < ActiveRecord::Base
  has_many :memberships
  has_many :card_sets, :through => :memberships

  validates_uniqueness_of :name
  validates_presence_of :name, :game, :expansion, :card_type
  validates_numericality_of :cost, :greater_than_or_equal_to => 0
end
