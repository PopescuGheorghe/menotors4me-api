class OrganizationFactory < Ability
  def initialize(user)
    can :read, :all
    can [:create], User
    can :update, Organization, organization: user.organization
    can [:update, :password, :destroy], User, id: user.id
    can :manage, Context, organization_id: user.id
  end
end
