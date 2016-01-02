class Ability
  include CanCan::Ability

  def initialize(user, request = nil)
    user ||= User.new
    identity = user.primary_identity
    
    # Return true if allowed
    can do |action, subject_class, subject|
      if !subject.nil?
        if !user.new_record?
          if subject.respond_to?("owner_id") && subject.owner_id == identity.id
            true
          else
            query = "user_id = ? and subject_class = ? and subject_id = ? and (action & #{Permission::ACTION_MANAGE} != 0"
            if action == :show
              query += " or action & #{Permission::ACTION_READ} != 0"
            elsif action == :edit || action == :update
              query += " or action & #{Permission::ACTION_UPDATE} != 0"
            elsif action == :destroy
              query += " or action & #{Permission::ACTION_DESTROY} != 0"
            else
              # If it's any other action, it's probably custom and so just
              # assume it's an edit
              query += " or action & #{Permission::ACTION_UPDATE} != 0"
            end
            query += ")"
            if Permission.where(query, user.id, Myp.model_to_category_name(subject_class), subject.id).length > 0
              true
            else
              Rails.logger.debug{"Returning false for #{user.id} #{action} #{Myp.model_to_category_name(subject_class)} #{subject.id}"}
              false
            end
          end
        else
          false
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
