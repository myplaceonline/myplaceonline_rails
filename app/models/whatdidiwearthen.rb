class Whatdidiwearthen < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :weartime, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :test_object_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :weartime, presence: true
  
  def display
    str = ""
    
    tmp = ""
    self.whatdidiwearthen_wearables.each do |wrapper|
      tmp = Myp.appendstr(tmp, wrapper.wearable.display, "; ")
    end
    
    if !tmp.blank?
      str = Myp.appendstr(str, "Wore #{tmp}", ", ")
    end
    
    tmp = ""
    self.whatdidiwearthen_contacts.each do |wrapper|
      tmp = Myp.appendstr(tmp, wrapper.contact.display, "; ")
    end
    
    if !tmp.blank?
      str = Myp.appendstr(str, "Saw #{tmp}", ", ")
    end
    
    tmp = ""
    self.whatdidiwearthen_locations.each do |wrapper|
      tmp = Myp.appendstr(tmp, wrapper.location.display_super_simple, "; ")
    end
    
    if !tmp.blank?
      str = Myp.appendstr(str, "Went to #{tmp}", ", ")
    end
    
    if str.blank?
      str = "No data entered"
    end
    
    return str
  end

  child_files
  child_properties(name: :whatdidiwearthen_wearables)
  child_properties(name: :whatdidiwearthen_contacts)
  child_properties(name: :whatdidiwearthen_locations)
end
