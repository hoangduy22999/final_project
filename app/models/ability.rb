# frozen_string_literal: true

class Ability
  include CanCan::Ability

  def initialize(user)
    return unless user.present?

    if user.user_department.role_leader?
      can %i[update read], LeaveRequest, approve_by: user.id
    end

    if user.role_admin?
      can :manage, :all
    elsif user.role_user? && user&.user_department&.role_leader?
      can :manage, LeaveRequest, approve_by: user.id
      can :manage, UserDepartment, department: user.department
      can :manage, User, department: user.department
    else
      can :manage, User, id: user.id
      can :manage, LeaveRequest, user_id: user.id
      can :manage, Contract, user_department_id: user.user_department.id
    end

    # Define abilities for the user here. For example:
    #
    #   return unless user.present?
    #   can :read, :all
    #   return unless user.admin?
    #   can :manage, :all
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
    #   can :update, Article, published: true
    #
    # See the wiki for details:
    # https://github.com/CanCanCommunity/cancancan/blob/develop/docs/define_check_abilities.md
  end
end
