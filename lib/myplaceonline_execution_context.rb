require "browser"

class MyplaceonlineExecutionContext
  def self.[](name)
    ExecutionContext[name]
  end
  
  def self.[]=(name, val)
    ExecutionContext[name] = val
  end
  
  def self.user; self[:user]; end
  def self.user=(x); self[:user] = x; end
  
  def self.handle_updates?; self[:handle_updates] == true; end
  def self.enable_handling_updates; self[:handle_updates] = true; end
  def self.disable_handling_updates; ExecutionContext.current.delete(:handle_updates); end

  def self.request; self[:request]; end
  def self.request=(x); self[:request] = x; end

  def self.session; self[:session]; end
  def self.session=(x); self[:session] = x; end

  def self.ability_context_identity; self[:ability_context_identity]; end
  def self.ability_context_identity=(x); self[:ability_context_identity] = x; end

  def self.permission_target; self[:permission_target]; end
  def self.permission_target=(x); self[:permission_target] = x; end

  def self.browser
    result = self[:permission_target]
    if result.nil?
      if !self.request.nil? && !self.request.user_agent.blank?
        result = Browser.new(self.request.user_agent, accept_language: self.request.env["HTTP_ACCEPT_LANGUAGE"])
        self[:permission_target] = result
      end
    end
    result
  end
end
