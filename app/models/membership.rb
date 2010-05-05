class Membership < ActiveRecord::Base
  belongs_to :card
  belongs_to :card_set

  # FIXME: validates_uniqueness_of won't allow saves in Membership model
  # The following code is BROKEN in rails 2.3.5.  For the time being, we'll
  # have to accept duplicate entries in the Memberships model until 2.3.6 releases.
  #
  #   correction:
  #   THIS code is not broken.  The broken code is in
  #   CardSet.accepts_nested_attributes_for, which creates duplicate entries in
  #   Membership for every nested model in the input (in this case, Cards) .
  #

#  validates_uniqueness_of :card_id, :scope => :card_set_id,
#                      :message => "may only be a member of the set once"
end
