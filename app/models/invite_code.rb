class InviteCode < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  child_property(name: :website_domain)
  
  validates :code, presence: true
  validates :max_uses, presence: true
  
  def display
    Myp.appendstrwrap(Myp.appendstrwrap(code, current_uses.to_s + "/" + max_uses.to_s), self.public_name)
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.current_uses = 0
    result
  end
  
  def self.get_code(code)
    if code.nil?
      code = ""
    end
    InviteCode.where(
      "LOWER(code) = ? AND current_uses < max_uses AND (website_domain_id IS NULL OR website_domain_id = ?)",
      code.downcase,
      Myp.website_domain
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
