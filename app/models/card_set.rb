class CardSet < ActiveRecord::Base
  belongs_to :creator, :class_name => "User"
  has_many :memberships

  # FIXME: workaround for duplicating records in CardSet model
  # the :uniq parameter below was added to deal with the
  # duplication bug detailed further below.  It does not fix
  # the problem, it only hides it from the results from us.
  has_many :cards, :through => :memberships, :uniq => true

  # FIXME: bug in rails 2.3.5 exposed in CardSet Model causing dupe records
  # The following code is BROKEN in rails 2.3.5.  The accepts_nested_attributes_for
  # method call creates duplicate entries in Membership for every nested model
  # in the input (in this case, Cards) .For the time being, we'll have to accept duplicate
  # entries in the Memberships model until 2.3.6 releases.
  accepts_nested_attributes_for :memberships, :cards

  validates_uniqueness_of :name
  validates_presence_of :creator_id, :name, :set_type

  named_scope :dominion_sets_of_10, :conditions => { :game => 'dominion', :set_type => 'Set of 10' }

  def show_custom
    custom ? 'custom' : ''
  end
end
