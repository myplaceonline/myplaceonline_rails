class Identity < ActiveRecord::Base
  belongs_to :owner, class_name: User
  has_many :passwords, :dependent => :destroy
  has_many :identity_files, :dependent => :destroy
  has_many :category_points_amounts, :dependent => :destroy
  
  def as_json(options={})
    super.as_json(options).merge({
      :passwords => passwords.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :identity_files => identity_files.to_a.map{|x| x.as_json},
      :category_points_amounts => category_points_amounts.to_a.map{|x| x.as_json}
    })
  end
end
