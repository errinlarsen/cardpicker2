class Membership < ActiveRecord::Base
  belongs_to :card
  belongs_to :card_set
end
