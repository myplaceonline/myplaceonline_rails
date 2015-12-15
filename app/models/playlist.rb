class Playlist < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :playlist_name, presence: true
  
  has_many :playlist_songs, -> { order('position ASC') }, :dependent => :destroy
  accepts_nested_attributes_for :playlist_songs, allow_destroy: true, reject_if: :all_blank
  
  has_many :playlist_shares

  def display
    playlist_name
  end
end
