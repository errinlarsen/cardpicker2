class Card < ActiveRecord::Base
  has_many :memberships
  has_many :card_sets, :through => :memberships
end
