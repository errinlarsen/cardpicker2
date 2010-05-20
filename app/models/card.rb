class Card < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  has_many :memberships
  has_many :card_sets, :through => :memberships

  validates_uniqueness_of :name, :scope => [:game, :expansion]
  validates_presence_of :creator_id, :name, :game, :expansion, :card_type, :cost

  POTION_VALUE = 3

  default_scope :order => 'game, expansion, name'
  named_scope :dominion, :conditions => { :game => 'dominion' }
  named_scope :start_player, :conditions => { :game => 'start_player' }
  named_scope :without_customs, :conditions => { :custom => false }

  def self.random_start_player_card
    Array.new( start_player ).shuffle.shift
  end

  def self.all_dominion_expansions
    dominion.collect { |card| card.expansion }.uniq
  end

  def dominion_cost_for_randomization
    chars = cost.chars
    chars.inject(0) { |sum, c| c == 'p' ? sum + POTION_VALUE : sum + c.to_i }
  end

  def dominion_cost_for_sort
    chars = cost.chars
    chars.inject(0) { |sum, c| c == 'p' ? sum + 0.5 : sum + c.to_i }
  end

  def card_ids
    cards.collect{ |c| c.id }
  end
end
