class MyplaceonlineModelBase < ActiveRecord::Base
  self.abstract_class = true
  
  def self.build(params = nil)
    result = self.new(params)
    result
  end
end
