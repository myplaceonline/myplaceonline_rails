# Actions: read, create, update, destroy, manage
class Ability
  include CanCan::Ability

  def initialize(user, request = nil)
    user ||= User.new
    identity = user.primary_identity
    
    # Return true if allowed
    can do |action, subject_class, subject|
      if !subject.nil?
        if subject.respond_to?("owner_id") && subject.owner_id == identity.id
          true
        else
          action_search = [0]
          if action == :show
            action_search.push(1)
          elsif action == :edit
            action_search.push(3)
          end
          if Permission.where(user: user, subject_class: Myp.model_to_category_name(subject_class), subject_id: subject.id, action: action_search).length > 0
            true
          else
            false
          end
        end
      else
        false
      end
    end
    
    if user.admin?
      can :manage, User
    end
  end
end
