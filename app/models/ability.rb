class Ability
  include CanCan::Ability

  def initialize(user)
    # Define abilities for the passed in user here. For example:
    user ||= User.new # guest user (not logged in)
    if user.is_admin?
      can :manage, :all
    elsif user.is_moderator?
      can [:read, :create, :update, :destroy], Subject
      can [:read, :create, :update, :destroy], Group
      can [:read, :create, :update, :destroy], Formula
      can [:read, :create, :update, :destroy], Parameter
      can [:read, :create, :update, :destroy], ParamVal
      can [:read, :create, :update, :destroy], ParamLevel
      can [:read, :create, :update, :destroy], ParamPreset
      can [:read, :create, :update, :destroy], Uom
    elsif user.is_operator?
      can [:read], Group
      can [:read], Formula
      can [:read], Parameter
      can [:read, :create, :update, :destroy], ParamVal
      can [:read], ParamLevel
      can [:read], ParamPreset
      can [:read], Uom
    elsif user.is_visitor?
      can [:read], Subject
      can [:read], Group
      can [:read], Parameter
      can [:read], ParamVal
      can [:read], ParamLevel
      can [:read], ParamPreset
      can [:read], Uom
      can [:read], Param
      can [:read], ParamValue
    end


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
    # https://github.com/ryanb/cancan/wiki/Defining-Abilities
  end
end
