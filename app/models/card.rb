class Card < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  has_many :memberships
  has_many :card_sets, :through => :memberships

  validates_uniqueness_of :name
  validates_presence_of :creator_id, :name, :game, :expansion, :card_type, :cost

  POTION_VALUE = 3
  
  def computed_cost
    chars = cost.chars
    chars.inject(0) { |sum, c| c == 'p' ? sum + POTION_VALUE : sum + c.to_i }
  end
end
