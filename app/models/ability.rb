class Ability
  include CanCan::Ability

  def initialize(user, request = nil)
    if user.nil?
      user = User.new
      identity = Identity.new(user: user)
    else
      identity = user.primary_identity
    end

    Rails.logger.debug{"Ability.initialize user: #{user.id}"}

    if !Ability.context_identity.nil?
      identity = Ability.context_identity
      Rails.logger.debug{"Ability.initialize identity from thread: #{identity.id}"}
    end
    
    can do |action, subject_class, subject|
      Ability.authorize(identity: identity, subject: subject, action: action, request: request, subject_class: subject_class)
    end
    
    if user.admin?
      can :manage, User
      can :manage, InviteCode
    end
  end

  def self.context_identity
    MyplaceonlineExecutionContext.ability_context_identity
  end

  def self.context_identity=(identity)
    MyplaceonlineExecutionContext.ability_context_identity = identity
  end
  
  def self.authorize(identity:, subject:, action: :edit, request: nil, subject_class: nil)
    result = false
    if identity.nil?
      user = User.new
      identity = Identity.new
    else
      user = identity.user
      if user.nil?
        user = User.new
      end
    end
    subject_class ||= subject.class

    Rails.logger.debug{"Ability.authorize user: #{user.id}"}

    if !Ability.context_identity.nil?
      identity = Ability.context_identity
      Rails.logger.debug{"Ability.authorize identity from thread: #{identity.id}"}
    end
    
    # If the user owns the object, then they can do anything;
    # Otherwise, check the Shares and Permissions tables
    
    Rails.logger.debug{"Ability.authorize checking action: #{action}, subject_class: #{subject_class}, subject: #{subject.id} with identity #{identity.id}"}
    
    if !subject.nil?
      
      if subject.respond_to?("permission_check_target")
        subject = subject.permission_check_target
        subject_class = subject.class
        Rails.logger.debug{"Ability.authorize Changing subject to: subject_class: #{subject_class}, subject: #{subject.id}"}
      end
      
      # If token is a query parameter, then check the share table
      if !request.nil? && !request.query_parameters.nil?
        token = request.query_parameters["token"]
        if !token.blank?
          Rails.logger.debug{"Ability.Found token: #{token}"}
          ps = PermissionShare.find_by_sql(%{
            SELECT permission_shares.*
            FROM permission_shares
              INNER JOIN shares on permission_shares.share_id = shares.id
            WHERE shares.token = #{ActiveRecord::Base.connection.quote(token)}
              AND permission_shares.subject_class = #{ActiveRecord::Base.connection.quote(subject.class.name)}
              AND permission_shares.subject_id = #{subject.id}
              AND (shares.max_use_count IS NULL OR shares.use_count + 1 <= shares.max_use_count)
          }).first
          if !ps.nil?
            result = true
            if !ps.share.use_count.nil?
              ps.share.update_column(:use_count, ps.share.use_count + 1)
            else
              ps.share.update_column(:use_count, 1)
            end
          end
          
          if !result
            psc = PermissionShareChild.find_by_sql(%{
              SELECT permission_share_children.*
              FROM permission_share_children
                INNER JOIN shares on permission_share_children.share_id = shares.id
              WHERE shares.token = #{ActiveRecord::Base.connection.quote(token)}
                AND permission_share_children.subject_class = #{ActiveRecord::Base.connection.quote(subject.class.name)}
                AND permission_share_children.subject_id = #{subject.id}
                AND (shares.max_use_count IS NULL OR shares.use_count + 1 <= shares.max_use_count)
            }).first
            if !psc.nil?
              result = true
              if !psc.share.use_count.nil?
                psc.share.update_column(:use_count, psc.share.use_count + 1)
              else
                psc.share.update_column(:use_count, 1)
              end
            end
          end
        end
      end
      
      if !result && !user.new_record?
        if subject.respond_to?("identity_id") && subject.identity_id == identity.id
          Rails.logger.debug{"Ability.authorize Identities match: subject: #{subject.id}, identity: #{identity.id}"}
          result = true
        else
          query = "user_id = ? and subject_class = ? and subject_id = ? and (action & #{Permission::ACTION_MANAGE} != 0"
          if action == :show
            query += " or action & #{Permission::ACTION_READ} != 0"
          elsif action == :edit || action == :update
            query += " or action & #{Permission::ACTION_UPDATE} != 0"
          elsif action == :destroy
            query += " or action & #{Permission::ACTION_DESTROY} != 0"
          elsif subject.respond_to?("permission_action")
            permission_action = subject.permission_action(action)
            query += " or action & #{permission_action} != 0"
          else
            # If it's any other action, it's probably custom and so just
            # assume it's an edit
            query += " or action & #{Permission::ACTION_UPDATE} != 0"
          end
          query += ")"
          permission_results = Permission.where(query, user.id, Myp.model_to_category_name(subject_class), subject.id)
          if permission_results.length > 0
            Rails.logger.debug{"Ability.authorize Found permissions: #{permission_results.inspect}"}
            result = true
          else
            Rails.logger.debug{"Ability.authorize Returning false for user: #{user.id}, action: #{action}, category: #{Myp.model_to_category_name(subject_class)}, subject: #{subject.id}"}
          end
        end
      end
    end

    if user.guest? && action != :show
      Rails.logger.debug{"Ability.authorize Guest can only do show action (tried #{action})"}
      result = false
    end

    Rails.logger.debug{"Ability.authorize returning #{result} for user #{user.id}, subject #{subject.inspect}"}
    
    result
  end
end
