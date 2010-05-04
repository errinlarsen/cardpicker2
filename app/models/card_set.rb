class CardSet < ActiveRecord::Base
  has_many :memberships

  # the :uniq parameter below was added to deal with the
  # duplication bug detailed further below.  It does not fix
  # the problem, it only hides it from the results from us.
  has_many :cards, :through => :memberships, :uniq => true

  # The following code is BROKEN in rails 2.3.5.  The accepts_nested_attributes_for
  # method call creates duplicate entries in Membership for every nested model
  # in the input (in this case, Cards) .For the time being, we'll have to accept duplicate
  # entries in the Memberships model until 2.3.6 releases.
  accepts_nested_attributes_for :memberships, :cards

  validates_uniqueness_of :name
  validates_presence_of :name, :set_type
end
