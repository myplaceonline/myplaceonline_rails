class InMemoryPersistentUserStore
  def initialize
    @holder = {}
  end
  
  def []=(name, val)
    @holder[name] = val
  end
  
  def [](name)
    @holder[name]
  end
  
  def delete(name)
    @holder.delete(name)
  end
  
  def clear
    @holder.clear
  end
end
