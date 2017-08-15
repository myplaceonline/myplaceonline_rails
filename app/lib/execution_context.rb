class ExecutionContext
  
  DEBUG_STACKING = false
  
  def initialize
    @map = Hash.new
  end
  
  def self.push(execution_context: ExecutionContext.new)
    execution_contexts = Thread.current[:execution_contexts]
    if execution_contexts.nil?
      execution_contexts = Array.new
      Thread.current[:execution_contexts] = execution_contexts
    end
    execution_contexts.push(execution_context)
    if ExecutionContext::DEBUG_STACKING
      Rails.logger.debug{"Pushed context:\n#{Myp.current_stack}"}
    end
    execution_context
  end
  
  def self.pop
    if ExecutionContext::DEBUG_STACKING
      Rails.logger.debug{"Popping context:\n#{Myp.current_stack}"}
    end
    execution_contexts = Thread.current[:execution_contexts]
    if !execution_contexts.nil?
      result = execution_contexts.pop
      if execution_contexts.length == 0
        self.clear
      end
      result
    else
      raise "Unmatched execution context pushes and pops"
    end
  end
  
  def self.clear
    Thread.current[:execution_contexts] = nil
    if ExecutionContext::DEBUG_STACKING
      Rails.logger.debug{"Cleared contexts:\n#{Myp.current_stack}"}
    end
  end
  
  def self.count
    execution_contexts = Thread.current[:execution_contexts]
    if execution_contexts.nil?
      0
    else
      execution_contexts.count
    end
  end
  
  def self.current
    execution_contexts = Thread.current[:execution_contexts]
    if !execution_contexts.nil?
      execution_contexts.last
    else
      raise "No execution contexts"
    end
  end
  
  def self.[](name)
    execution_contexts = Thread.current[:execution_contexts]
    #Rails.logger.debug{"ExecutionContext.[] name: #{name}"}
    if !execution_contexts.nil?
      result = nil
      i = execution_contexts.length - 1
      while result.nil? && i >= 0
        execution_context = execution_contexts[i]
        result = execution_context[name]
        #Rails.logger.debug{"ExecutionContext.[] result of #{i}: #{result}"}
        i -= 1
      end
      #Rails.logger.debug{"ExecutionContext.[] returning: #{result}"}
      result
    else
      raise "No execution contexts"
    end
  end
  
  def self.get(name, default: nil)
    result = ExecutionContext[name]
    if result.nil?
      result = default
    end
    result
  end

  def self.[]=(name, val)
    self.current[name] = val
  end

  def self.delete()
    execution_contexts = Thread.current[:execution_contexts]
    if !execution_contexts.nil?
      i = execution_contexts.length - 1
      while i >= 0
        execution_context = execution_contexts[i]
        result = execution_context[name]
        if !result.nil?
          execution_context.delete(name)
          break
        end
        i -= 1
      end
      result
    else
      raise "No execution contexts"
    end
  end

  def self.root
    execution_contexts = Thread.current[:execution_contexts]
    if !execution_contexts.nil?
      execution_contexts.first
    else
      raise "No execution contexts"
    end
  end
  
  def self.root_or_push
    execution_contexts = Thread.current[:execution_contexts]
    if !execution_contexts.nil?
      execution_contexts.first
    else
      self.push
    end
  end

  def self.push_marker(name)
    final_name = "marker_" + name.to_s
    x = self.root[final_name]
    if x.nil?
      x = 0
    end
    x = x + 1
    self.root[final_name] = x
    x
  end
  
  def self.pop_marker(name)
    final_name = "marker_" + name.to_s
    x = self.root[final_name]
    if x.nil?
      raise "Unmatced push_marker"
    end
    x = x - 1
    self.root[final_name] = x
    x
  end

  def self.available?
    self.count > 0
  end

  def self.stack(**options, &block)
    context = ExecutionContext.push
    # We don't need to delete these in the ensure, since they just go away on the pop
    options.each do |key, value|
      context[key] = value
    end
    begin
      block.call
    ensure
      ExecutionContext.pop
    end
  end

  def [](name)
    @map[name]
  end

  def []=(name, val)
    @map[name] = val
  end
  
  def delete(name)
    @map.delete(name)
  end
end
