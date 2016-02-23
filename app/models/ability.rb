class Ability
  include CanCan::Ability

  def initialize(user, request = nil)
    user ||= User.new
    identity = user.primary_identity
    
    # If the user owns the object, then they can do anything;
    # Otherwise, check the Shares and Permissions tables
    
    can do |action, subject_class, subject|
      result = false
      if !subject.nil?
        
        # If token is a query parameter, then check the share table
        if !request.nil? && !request.query_parameters.nil?
          token = request.query_parameters["token"]
          if !token.blank?
            if !PermissionShare.find_by_sql(%{
              SELECT permission_shares.*
              FROM permission_shares
                INNER JOIN shares on permission_shares.share_id = shares.id
              WHERE shares.token = #{ActiveRecord::Base.sanitize(token)}
                AND permission_shares.subject_class = #{ActiveRecord::Base.sanitize(subject.class.name)}
                AND permission_shares.subject_id = #{subject.id}
            }).first.nil?
              result = true
            end
            
            if !result
              if !PermissionShareChild.find_by_sql(%{
                SELECT permission_share_children.*
                FROM permission_share_children
                  INNER JOIN shares on permission_share_children.share_id = shares.id
                WHERE shares.token = #{ActiveRecord::Base.sanitize(token)}
                  AND permission_share_children.subject_class = #{ActiveRecord::Base.sanitize(subject.class.name)}
                  AND permission_share_children.subject_id = #{subject.id}
              }).first.nil?
                result = true
              end
            end
          end
        end
        
        if !result && !user.new_record?
          if subject.respond_to?("identity_id") && subject.identity_id == identity.id
            result = true
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
              result = true
            else
              Rails.logger.debug{"Returning false for #{user.id} #{action} #{Myp.model_to_category_name(subject_class)} #{subject.id}"}
            end
          end
        end
      end
      Rails.logger.debug{"Authorize returning #{result} for user #{user.id}, subject #{subject}"}
      result
    end
    
    if user.admin?
      can :manage, User
      can :manage, InviteCode
    end
  end
end
