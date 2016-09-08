class ExecutionContext
  
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
    execution_context
  end
  
  def self.pop
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
    if !execution_contexts.nil?
      result = nil
      i = execution_contexts.length - 1
      while result.nil? && i >= 0
        execution_context = execution_contexts[i]
        result = execution_context[name]
        i -= 1
      end
      result
    else
      raise "No execution contexts"
    end
  end

  def self.[]=(name, val)
    self.current[name] = val
  end

  def [](name)
    @map[name]
  end

  def []=(name, val)
    @map[name] = val
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
end
