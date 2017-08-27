class DynamicDefaultUrlOptions
  def initialize(params = {})
    @params = params
  end
  
  def method_missing(name, *args, &block)
    if name.to_s == "[]" && args && args.length > 0 && args[0] == :host
      MyplaceonlineExecutionContext.host
    else
      @params.send(name, *args, &block)
    end
  end
end
