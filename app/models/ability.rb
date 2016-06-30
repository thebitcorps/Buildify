class Ability
  include CanCan::Ability

  def initialize(user)
    user ||= User.new
    if user.administrator?
      can :manage, :all
    elsif user.subordinate?
      can [:read, :update], Construction
      can [:read, :update, :destroy,:create], ItemMaterial
      can :read, MeasureUnit
      can :manage, Requisition
      can :read, User, id: user.id
      can [:read, :create], Material
      can :manage, PettyCash
      can :manage, PettyCashExpense
      can :manage, Notification
    elsif user.secretary?
      can :read, User
      can :read, Construction
      can :read, Provider
      can :manage, Invoice
      can :manage, Material
      can :read, PettyCash
      can :read, PettyCashExpense
      can :manage, Notification
    end
    # Define abilities for the passed in user here. For example:
    #
    #   user ||= User.new # guest user (not logged in)
    #   if user.admin?
    #     can :manage, :all
    #   else
    #     can :read, :all
    #   end
    #
    # The first argument to `can` is the action you are giving the user
    # permission to do.
    # If you pass :manage it will apply to every action. Other common actions
    # here are :read, :create, :update and :destroy.
    #
    # The second argument is the resource the user can perform the action on.
    # If you pass :all it will apply to every resource. Otherwise pass a Ruby
    # class of the resource.
    #
    # The third argument is an optional hash of conditions to further filter the
    # objects.
    # For example, here the user can only update published articles.
    #
    #   can :update, Article, :published => true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/wiki/Defining-Abilities
  end
end
