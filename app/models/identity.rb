class Identity < ActiveRecord::Base
  belongs_to :owner, class_name: User
  has_many :passwords, :dependent => :destroy
  has_many :identity_files, :dependent => :destroy
  has_many :category_points_amounts, :dependent => :destroy
  has_many :movies, :dependent => :destroy
  has_many :wisdoms, :dependent => :destroy
  has_many :to_dos, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :accomplishments, :dependent => :destroy
  has_many :feeds, :dependent => :destroy
  has_many :locations, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :apartments, :dependent => :destroy
  
  def as_json(options={})
    super.as_json(options).merge({
      :category_points_amounts => category_points_amounts.to_a.map{|x| x.as_json},
      :passwords => passwords.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :movies => movies.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :wisdoms => wisdoms.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :to_dos => to_dos.to_a.sort{ |a,b| a.short_description.downcase <=> b.short_description.downcase }.map{|x| x.as_json},
      :contacts => contacts.to_a.delete_if{|x| x.ref_id == id }.map{|x| x.as_json},
      :accomplishments => accomplishments.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :feeds => feeds.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :locations => locations.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :activities => activities.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :apartments => apartments.to_a.map{|x| x.as_json},
      :identity_files => identity_files.to_a.map{|x| x.as_json}
    })
  end
  
  def ensure_contact!
    if Contact.find_by(
      identity_id: id,
      ref_id: id
    ).nil?
      ActiveRecord::Base.transaction do
        me = Contact.new
        if self.name.blank?
          self.name = I18n.t("myplaceonline.contacts.me")
          self.save!
        end
        me.identity = self
        me.ref = self
        me.save!
      end
    end
  end
end
