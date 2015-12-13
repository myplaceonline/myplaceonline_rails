class ImportMuseums < ActiveRecord::Migration
  disable_ddl_transaction!

  def change
    file = Rails.root.join('lib', 'data', 'mudf', 'mudf15q3pub_csv.csv')

    User.current_user = User.find(0)

    line_count = `wc -l "#{file.to_s}"`.strip.split(' ')[0].to_i
    puts "Entries: #{line_count}"

    f = File.open(file.to_s, "rb")
    contents = f.read.encode!("UTF-8", :undef => :replace, :invalid => :replace, :replace => "")
    count = 1

    CSV.parse(contents, { headers: true, skip_blanks: true }) do |row|
      m = Museum.new 
      m.location = Location.new
      m.location.owner = User.current_user.primary_identity
      m.location.name = row["COMMONNAME"].titleize
      m.location.region = "US"
      if !row["GSTREET"].blank?
        m.location.address1 = row["GSTREET"].titleize
      end
      if !row["GSTATE"].blank?
        m.location.sub_region1 = row["GSTATE"]
      end
      if !row["GCITY"].blank?
        m.location.sub_region2 = row["GCITY"].titleize
      end
      if !row["GZIP"].blank?
        m.location.postal_code = row["GZIP"]
      end
      m.location.latitude = row["LATITUDE"]
      m.location.longitude = row["LONGITUDE"]
      if !row["PHONE"].blank?
        phone = LocationPhone.new
        phone.owner = User.current_user.primary_identity
        phone.number = row["PHONE"]
        m.location.location_phones << phone
      end
      if !row["WEBURL"].blank?
        m.website = Website.new
        m.website.owner = User.current_user.primary_identity
        m.website.url = row["WEBURL"].downcase
        m.website.title = m.location.name
      end
      m.owner = User.current_user.primary_identity
      m.museum_id = row["MID"]
      m.museum_source = "mudf"
      museum_type = row["DISCIPL"]
      if museum_type == "ART"
        m.museum_type = 0
      elsif museum_type == "BOT"
        m.museum_type = 1
      elsif museum_type == "CMU"
        m.museum_type = 2
      elsif museum_type == "GMU"
        m.museum_type = 3
      elsif museum_type == "HSC"
        m.museum_type = 4
      elsif museum_type == "HST"
        m.museum_type = 5
      elsif museum_type == "NAT"
        m.museum_type = 6
      elsif museum_type == "SCI"
        m.museum_type = 7
      elsif museum_type == "ZAW"
        m.museum_type = 8 
      end
      m.save!

      if (count % 1000) == 0
        puts "Processed #{count} rows"
      end

      count = count + 1
    end
  end
end
