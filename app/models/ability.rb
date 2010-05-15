class Ability
  include CanCan::Ability


  def initialize( user )
    user ||= User.new # User hasn't logged in

    if user.admin?
      # Only the Admin
      can :manage, :all if user.admin?

    else
      # All users, including guests:
      can :read, [Card, CardSet]
      can [:random, :random_options], CardSet
      can :random, Card

      # All users, except guests:
      can :create, CardSet unless user.guest?
      can :update, [Card, CardSet] do |c|
        # All users (except guests)  can edit the Cards and
        # CardSets they've created and Editors can edit any
        # Cards or CardSet
         
        c.try( :creator ) == user || user.editor?
      end

      if user.editor?
        # Editors only:
        can [:create, :update], [Card, CardSet]
      end
    end
  end
end
