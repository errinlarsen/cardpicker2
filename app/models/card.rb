class Card < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  has_many :memberships
  has_many :card_sets, :through => :memberships

  validates_uniqueness_of :name
  validates_presence_of :creator_id, :name, :game, :expansion, :card_type, :cost

  POTION_VALUE = 3

  named_scope :dominion, lambda { |*args|
    expansions = args.first || all.collect { |card| card.expansion }.uniq
    { :conditions => { :game => 'dominion', :custom =>false, :expansion => expansions }}
  } do
    def all_expansions
      all( :select => 'DISTINCT expansion').collect { |card| card.expansion }
    end
  end

  named_scope :dominion_with_custom, lambda { |*expansions|
    expansions = expansions.first || all.collect { |card| card.expansion }.uniq
    { :conditions => { :game => 'dominion', :expansion => expansions }}
  }

  named_scope :start_player, :conditions => { :game => 'start_player', :custom => false }
  named_scope :start_player_with_custom, :conditions => { :game => 'start_player' }
  
  def computed_cost
    chars = cost.chars
    chars.inject(0) { |sum, c| c == 'p' ? sum + POTION_VALUE : sum + c.to_i }
  end

  def sort_cost
    chars = cost.chars
    chars.inject(0) { |sum, c| c == 'p' ? sum + 0.5 : sum + c.to_i }
  end
end
