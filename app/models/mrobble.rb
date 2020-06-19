class Mrobble < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :mrobble_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :mrobble_link, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :stopped_watching_time, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :finished, type: ApplicationRecord::PROPERTY_TYPE_BOOLEAN },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :mrobble_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :mrobble_name, presence: true
  
  def display
    mrobble_name
  end

  child_files

  def restart_link
    if self.stopped_watching_time.blank?
      nil
    else
      result = self.mrobble_link
      secs = 0
      iteration = 0
      process = self.stopped_watching_time.strip
      i = process.rindex(":")
      while !i.nil?
        
        if iteration == 0
          secs = secs + process[i+1..-1].to_i
        elsif iteration == 1
          secs = secs + (process[i+1..-1].to_i * 60)
        elsif iteration == 2
          secs = secs + (process[i+1..-1].to_i * 60 * 60)
        end
        
        iteration = iteration + 1
        process = process[0..i-1]
        i = process.rindex(":")
      end
      
      if iteration == 0
        secs = secs + process.to_i
      elsif iteration == 1
        secs = secs + (process.to_i * 60)
      elsif iteration == 2
        secs = secs + (process.to_i * 60 * 60)
      end
      
      result + "&t=#{secs}s"
    end
  end
end
