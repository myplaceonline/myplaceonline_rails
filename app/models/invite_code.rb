class InviteCode < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :code, presence: true
  validates :max_uses, presence: true
  
  def display
    code + " (" + current_uses.to_s + "/" + max_uses.to_s + ")"
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.current_uses = 0
    result
  end
  
  def self.get_code(code)
    InviteCode.where(
      "lower(code) = ? and current_uses < max_uses",
      code.downcase
    ).first
  end
  
  def self.valid_code?(code)
    !get_code(code).nil?
  end
  
  def self.increment_code(code)
    code_obj = get_code(code)
    code_obj.update_column(:current_uses, code_obj.current_uses + 1)
  end
end
