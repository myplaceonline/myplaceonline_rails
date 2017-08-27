require "browser"

class MyplaceonlineExecutionContext
  def self.[](name)
    ExecutionContext[name]
  end
  
  def self.[]=(name, val)
    ExecutionContext[name] = val
  end
  
  def self.initialized; self[:initialized]; end
  def self.initialized=(x); self[:initialized] = x; end

  def self.user; self[:user]; end
  def self.user=(x); self[:user] = x; end
  
  def self.handle_updates?; self[:skip_handling_updates].nil?; end

  def self.request; self[:request]; end
  def self.request=(x); self[:request] = x; end

  def self.ability_context_identity; self[:ability_context_identity]; end
  def self.ability_context_identity=(x); self[:ability_context_identity] = x; end

  def self.permission_target; self[:permission_target]; end
  def self.permission_target=(x); self[:permission_target] = x; end

  def self.persistent_user_store; self[:persistent_user_store]; end
  def self.persistent_user_store=(x); self[:persistent_user_store] = x; end

  def self.query_string; self[:query_string]; end
  def self.query_string=(x); self[:query_string] = x; end

  def self.cookie_hash; self[:cookie_hash]; end
  def self.cookie_hash=(x); self[:cookie_hash] = x; end

  def self.host
    result = nil
    
    # Check if the host is emulated
    query_string = self.query_string
    if !query_string.nil?
      ehi = query_string.index("emulate_host=")
      if !ehi.nil?
        result = query_string[ehi+13..-1]
      end
    end
    
    cookie_hash = self.cookie_hash
    if !cookie_hash.nil?
      result = cookie_hash["emulate_host"]
    end

    if result.blank?
      result = self[:host]
    end

    if result.blank?
      result = Myp.default_host
    end
    
    result
  end
  
  def self.host=(x); self[:host] = x; end

  def self.browser
    result = self[:browser]
    if result.nil?
      if !self.request.nil? && !self.request.user_agent.blank?
        result = Browser.new(self.request.user_agent, accept_language: self.request.env["HTTP_ACCEPT_LANGUAGE"])
        self[:browser] = result
      end
    end
    result
  end
  
  def self.do_permission_target(target, &block)
    ExecutionContext.push
    begin
      self.permission_target = target
      block.call
    ensure
      ExecutionContext.pop
    end
  end
  
  def self.do_user(user, &block)
    ExecutionContext.push
    begin
      self.user = user
      block.call
    ensure
      ExecutionContext.pop
    end
  end

  def self.do_identity(identity, &block)
    ExecutionContext.push
    begin
      self.user = identity.user
      block.call
    ensure
      ExecutionContext.pop
    end
  end

  def self.do_context(context, &block)
    ExecutionContext.push
    begin
      self.user = context.identity.user
      block.call
    ensure
      ExecutionContext.pop
    end
  end

  def self.do_ability_identity(identity, &block)
    ExecutionContext.push
    begin
      self.ability_context_identity = identity
      block.call
    ensure
      ExecutionContext.pop
    end
  end

  def self.disable_handling_updates(&block)
    begin
      self[:skip_handling_updates] = true
      block.call
    ensure
      ExecutionContext.current.delete(:skip_handling_updates)
    end
  end
  
  def self.initialize(request:, session:, user:, persistent_user_store:)
    MyplaceonlineExecutionContext.request = request
    
    Rails.logger.debug{"MyplaceonlineExecutionContext.initialize user: #{user.nil? ? "nil" : user.id}"}

    MyplaceonlineExecutionContext.user = user
    
    if !user.nil?
      session[:myp_email] = user.email
    end

    MyplaceonlineExecutionContext.persistent_user_store = persistent_user_store
  end
  
  # This should mostly be used only for debugging since the context is not unset
  def self.set(user: nil, identity: nil, context: nil)
    ExecutionContext.push
    if !user.nil?
      result = self.user = user
    end
    if !identity.nil?
      result = self.user = identity.user
    end
    if !context.nil?
      result = self.user = context.identity.user
    end
    result
  end
end
