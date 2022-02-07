class Ability
  include CanCan::Ability

  def initialize user
    user ||= User.new
    return if user.blank?

    if user.admin?
      can :manage, :all
    elsif user.manager?
      can :read, :all
      can :manage, Order
    else
      can %i(new create), Order
      can :update, Order, user_id: user.id
    end
  end
end
