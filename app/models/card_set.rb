class CardSet < ActiveRecord::Base
  has_many :memberships
  has_many :cards, :through => :memberships
end
