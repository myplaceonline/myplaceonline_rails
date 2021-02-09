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
  
  def self.find_code(code)
    if code.nil?
      code = ""
    end
    InviteCode.where(
      "LOWER(code) = ? AND (website_domain_id IS NULL OR website_domain_id = ?)",
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
  
  def get_parent
    if !self.parent_id.nil?
      return Myp.find_existing_object(InviteCode, self.parent_id)
    end
    return nil
  end
  
  def parent_and_child_codes
    result = [self.code]
    if !self.parent_id.nil?
      result = InviteCode.where("parent_id = ? or id = ?", self.parent_id, self.parent_id).map{|ic| ic.code}
    end
    return result
  end
  
  def context_ids_array
    if !self.context_ids.blank?
      return self.context_ids.split(",")
    else
      return []
    end
  end
  
  def parent_and_child_context_ids
    result = self.context_ids_array
    if !self.parent_id.nil?
      result = InviteCode.where("parent_id = ? or id = ?", self.parent_id, self.parent_id).map{|ic| ic.context_ids_array }.flatten
    end
    return result
  end
end
