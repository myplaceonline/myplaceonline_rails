# Actions: read, create, update, destroy, manage
class Ability
  include CanCan::Ability

  def initialize(user, request = nil)
    user ||= User.new
    identity = user.primary_identity
    
    # Return true if allowed
    can do |action, subject_class, subject|
      if !subject.nil? && subject.respond_to?("owner_id") && subject.owner_id == identity.id
        true
      else
        false
      end
    end
    
    if user.admin?
      can :manage, User
    end
  end
end
