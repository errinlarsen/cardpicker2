class Membership < ActiveRecord::Base
  belongs_to :card
  belongs_to :card_set

  validates_uniqueness_of :card_id, :scope => :card_set_id,
                      :message => "may only be a member of the set once"
end
