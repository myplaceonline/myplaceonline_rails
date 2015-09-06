# x_coordinate:integer y_coordinate:integer title:string category_name:string category_id:integer border_type:integer collapsed:boolean
class Myplet < MyplaceonlineIdentityRecord
  def display
    nil
  end
  
  def self.default_myplets
    result = Array.new
    result.push(Myplet.new({y_coordinate: 0, x_coordinate: 0, title: ""}))
    result
  end
end
