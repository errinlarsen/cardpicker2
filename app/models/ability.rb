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

      # All users, except guests:
      can :create, CardSet unless user.guest?
      can :edit, CardSet do |card_set|
        # All users (except guests)  can edit the CardSets
        # they've created and Editors can edit any CardSet
        #
        # TODO: implement the next line in the CardSet model:
        # card_set.try( :user ) == user ||
        user.editor?
      end

      if user.editor?
        # Editors only:
        can [:create, :edit], Card
      end
    end
  end
end
