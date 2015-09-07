class Status < MyplaceonlineIdentityRecord
  FEELINGS = [
    ["myplaceonline.statuses.feeling_okay", 0],
    ["myplaceonline.statuses.feeling_happy", 1],
    ["myplaceonline.statuses.feeling_sad", 2],
    ["myplaceonline.statuses.feeling_meh", 3],
    ["myplaceonline.statuses.feeling_anxious", 4],
    ["myplaceonline.statuses.feeling_depressed", 5],
    ["myplaceonline.statuses.feeling_excited", 6],
    ["myplaceonline.statuses.feeling_angry", 7],
    ["myplaceonline.statuses.feeling_nervous", 8],
    ["myplaceonline.statuses.feeling_alien", 9],
    ["myplaceonline.statuses.feeling_lonely", 10],
    ["myplaceonline.statuses.feeling_tired", 11],
    ["myplaceonline.statuses.feeling_crazy", 12],
    ["myplaceonline.statuses.feeling_confused", 13],
    ["myplaceonline.statuses.feeling_confident", 14],
    ["myplaceonline.statuses.feeling_scared", 15],
    ["myplaceonline.statuses.feeling_hungry", 16],
    ["myplaceonline.statuses.feeling_injured", 17],
    ["myplaceonline.statuses.feeling_loving", 18],
    ["myplaceonline.statuses.feeling_sick", 19],
    ["myplaceonline.statuses.feeling_shameful", 20],
    ["myplaceonline.statuses.feeling_shocked", 21],
    ["myplaceonline.statuses.feeling_nothing", 22],
    ["myplaceonline.statuses.feeling_stupid", 23]
  ]

  validates :status_time, presence: true
  
  def display
    Myp.display_datetime(status_time, User.current_user)
  end
  
  def self.build(params = nil)
    result = super(params)
    result.status_time = DateTime.now
    result
  end
end
