class DynamicDefaultUrlOptions
  def initialize(params = {})
    @params = params
  end
  
  def method_missing(name, *args, &block)
    @params[:host] = MyplaceonlineExecutionContext.host
    @params.send(name, *args, &block)
  end
end
