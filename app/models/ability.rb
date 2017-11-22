class Ability
  include CanCan::Ability

  def initialize(user, request = nil)
    if user.nil?
      Rails.logger.debug{"Ability.initialize no user, setting to Guest"}
      user = User.guest
      identity = Identity.new(user: user)
    else
      identity = user.current_identity
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
    
    Rails.logger.debug{"Ability.authorize identity: #{identity}"}
    
    if identity.nil?
      Rails.logger.debug{"Ability.authorize no identity specified, setting to Guest"}
      user = User.guest
      identity = User.guest.current_identity
    else
      user = identity.user
      if user.nil?
        Rails.logger.debug{"Ability.authorize no user exists, setting to Guest"}
        user = User.guest
      end
    end
    
    subject_class ||= subject.class

    Rails.logger.debug{"Ability.authorize user: #{user.inspect}"}
    Rails.logger.debug{"Ability.authorize identity: #{identity.inspect}"}

    if !Ability.context_identity.nil?
      identity = Ability.context_identity
      Rails.logger.debug{"Ability.authorize identity from thread: #{identity.id}"}
    end
    
    # If the user owns the object, then they can do anything;
    # Otherwise, check the Shares and Permissions tables
    
    Rails.logger.debug{"Ability.authorize checking action: #{action}, subject_class: #{subject_class}, subject: #{subject.id} with user #{user.id}, identity #{identity.id}"}
    
    valid_guest_actions = [:show]
    
    if !subject.nil?
      
      if subject.respond_to?("permission_check_target")
        subject = subject.permission_check_target
        subject_class = subject.class
        Rails.logger.debug{"Ability.authorize Changing subject to: subject_class: #{subject_class}, subject: #{subject.id}"}
      end
      
      if !result && subject.respond_to?("identity_id") && subject.identity_id == identity.id
        Rails.logger.debug{"Ability.authorize Identities match: subject: #{subject.id}, identity: #{identity.id}"}
        result = true
      end
      
      if !result && subject.respond_to?("user_id") && subject.user_id == user.id
        Rails.logger.debug{"Ability.authorize Users match"}
        result = true
      end

      if !result && subject.respond_to?("is_public?") && subject.is_public?
        Rails.logger.debug{"Ability.authorize is_public true"}
        result = true
      end

      if !result && user.admin? && subject.respond_to?("allow_admin?") && subject.allow_admin?
        Rails.logger.debug{"Ability.authorize allowing admin"}
        result = true
      end

      # If token is a query parameter, then check the share table
      if !result && !request.nil? && !request.query_parameters.nil?
        token = request.query_parameters["token"]
        Rails.logger.debug{"Ability.authorize Has request and query params; token: #{token}"}
        if !token.blank?
          Rails.logger.debug{"Ability.authorize checking PermissionShare by token"}
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
            
            Rails.logger.debug{"Ability.authorize Found permission share #{Myp.debug_print(ps)}"}
            
            if !ps.valid_guest_actions.blank?
              valid_guest_actions = ps.valid_guest_actions.split(",").map{|x| x.to_sym}
              Rails.logger.debug{"Ability.authorize valid_guest_actions #{valid_guest_actions}"}
            end
            
            if !ps.share.use_count.nil?
              ps.share.update_column(:use_count, ps.share.use_count + 1)
            else
              ps.share.update_column(:use_count, 1)
            end
          end
          
          if !result
            
            Rails.logger.debug{"Ability.authorize checking PermissionShareChild"}
            
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
      
      if !result && (!user.new_record? || user.guest?)
        query = "(user_id = ? or user_id IS NULL) and subject_class = ? and subject_id = ? and (action & #{Permission::ACTION_MANAGE} != 0"
        query = self.add_action_query_parts(action: action, query: query, subject: subject)
        query += ")"
        Rails.logger.debug{"Ability.authorize checking Permission #{query}"}
        permission_result = Permission.where(query, user.id, Myp.model_to_category_name(subject_class), subject.id).last
        if !permission_result.nil?
          Rails.logger.debug{"Ability.authorize Found permissions: #{permission_result.inspect}"}
          result = true
          if !permission_result.valid_guest_actions.blank?
            valid_guest_actions = permission_result.valid_guest_actions.split(",").map{|x| x.to_sym}
            Rails.logger.debug{"Ability.authorize valid_guest_actions #{valid_guest_actions}"}
          end
        else
          Rails.logger.debug{"Ability.authorize no direct permission found"}
        end
        
        if !result
          query = "(user_id = :user_id or user_id IS NULL) and subject_class = :subject_class and target_identity_id = :target_identity_id and (action & #{Permission::ACTION_MANAGE} != 0"
          query = self.add_action_query_parts(action: action, query: query, subject: subject)
          query += ")"
          category_permissions = CategoryPermission.where(
            query,
            user_id: user.id,
            subject_class: Myp.model_to_category_name(subject_class),
            target_identity_id: subject.identity_id
          )
          if category_permissions.length > 0
            Rails.logger.debug{"Ability.authorize Found category permissions: #{category_permissions.inspect}"}
            result = true
          else
            Rails.logger.debug{"Ability.authorize category permission not found for user: #{user.id}, action: #{action}, category: #{Myp.model_to_category_name(subject_class)}, subject: #{subject.id}"}
          end
        end
      end
    end

    if result && user.guest? && valid_guest_actions.index(action).nil?
      Rails.logger.debug{"Ability.authorize Guest can only do #{valid_guest_actions} actions (tried #{action})"}
      result = false
    end
    
    if result && action != :show && subject.respond_to?("read_only?") && subject.read_only? && !user.admin?
      Rails.logger.debug{"Ability.authorize subject readonly"}
      result = false
    end

    Rails.logger.debug{"Ability.authorize returning #{result} for user #{user.id}, subject #{subject.inspect}"}
    
    result
  end
  
  def self.add_action_query_parts(action:, query:, subject:)
    
    permission = Permission::ACTION_UPDATE
    
    if action == :show
      permission = Permission::ACTION_READ
    elsif action == :edit || action == :update
      permission = Permission::ACTION_UPDATE
    elsif action == :destroy
      permission = Permission::ACTION_DESTROY
    elsif subject.respond_to?("unknown_action_permission_mapping")
      permission = subject.unknown_action_permission_mapping(action)
    elsif subject.respond_to?("permission_action")
      permission = subject.permission_action(action)
    else
      # If it's any other action, it's probably custom and so just
      # assume it's an edit
      permission = Permission::ACTION_UPDATE
    end
    
    query += " or action & #{permission} != 0"
    
    Rails.logger.debug{"Ability.add_action_query_parts added #{permission} for action: #{action}, subject: #{subject}"}
    
    query
  end
end
