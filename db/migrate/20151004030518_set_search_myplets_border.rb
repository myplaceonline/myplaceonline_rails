class SetSearchMypletsBorder < ActiveRecord::Migration
  def change
    Myplet.where(category_name: "myplaceonline_searches").each do |myplet|
      User.current_user = myplet.owner.owner
      myplet.border_type = 0
      myplet.save!
    end
  end
end
