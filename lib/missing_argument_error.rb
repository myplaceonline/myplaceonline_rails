class MissingArgumentError < ArgumentError
  def self.new(argument)
    super("Missing argument #{argument.to_s}")
  end
  
  def self.check(name:, value:)
    if value.nil?
      raise MissingArgumentError.new(name)
    end
  end
  
  def self.check_hash(name:, hash:)
    if hash[name].nil?
      raise MissingArgumentError.new(name)
    end
  end
end
