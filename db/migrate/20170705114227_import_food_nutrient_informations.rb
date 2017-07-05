class ImportFoodNutrientInformations < ActiveRecord::Migration[5.1]
  disable_ddl_transaction!

  def change
    MyplaceonlineExecutionContext.do_user(User.super_user) do
      UsdaNutrientDatabase::Nutrient.all.each do |nutrient|
        name = nutrient.nutrient_description

        # https://www.ars.usda.gov/ARSUserFiles/80400525/Data/SR/SR28/sr28_doc.pdf page 23
        case nutrient.nutrient_number
        when "607"
          name = Myp.appendstr(name, Myp.appendstrwrap("butyric", "butanoic")) + " acid"
        when "608"
          name = Myp.appendstr(name, Myp.appendstrwrap("caproic", "hexanoic")) + " acid"
        when "609"
          name = Myp.appendstr(name, Myp.appendstrwrap("caprylic", "octanoic")) + " acid"
        when "610"
          name = Myp.appendstr(name, Myp.appendstrwrap("capric", "decanoic")) + " acid"
        when "611"
          name = Myp.appendstr(name, Myp.appendstrwrap("lauric", "dodecanoic")) + " acid"
        when "696"
          name = name + " tridecanoic acid"
        when "612"
          name = Myp.appendstr(name, Myp.appendstrwrap("myristic", "tetradecanoic")) + " acid"
        when "652"
          name = name + " pentadecanoic acid"
        when "613"
          name = Myp.appendstr(name, Myp.appendstrwrap("palmitic", "hexadecanoic")) + " acid"
        when "653"
          name = Myp.appendstr(name, Myp.appendstrwrap("margaric", "heptadecanoic")) + " acid"
        when "614"
          name = Myp.appendstr(name, Myp.appendstrwrap("stearic", "octadecanoic")) + " acid"
        when "615"
          name = Myp.appendstr(name, Myp.appendstrwrap("arachidic", "eicosanoic")) + " acid"
        when "624"
          name = Myp.appendstr(name, Myp.appendstrwrap("behenic", "docosanoic")) + " acid"
        when "654"
          name = Myp.appendstr(name, Myp.appendstrwrap("lignoceric", "tetracosanoic")) + " acid"
        when "625"
          name = Myp.appendstr(name, Myp.appendstrwrap("myristoleic", "tetradecenoic")) + " acid"
        when "697"
          name = name + " pentadecenoic acid"
        when "626", "673", "662"
          name = Myp.appendstr(name, Myp.appendstrwrap("palmitoleic", "hexadecenoic")) + " acid"
        when "687"
          name = name + " heptadecenoic acid"
        when "617", "674", "663"
          name = Myp.appendstr(name, Myp.appendstrwrap("oleic", "octadecenoic")) + " acid"
        when "628"
          name = Myp.appendstr(name, Myp.appendstrwrap("gadoleic", "eicosenoic")) + " acid"
        when "630", "664"
          name = name + " docosenoic acid"
        when "676"
          name = Myp.appendstr(name, Myp.appendstrwrap("erucic/citoleic", "docosenoic")) + " acid"
        when "671"
          name = Myp.appendstr(name, Myp.appendstrwrap("nervonic", "cis-tetracosenoic")) + " acid"
        when "618", "665", "666", "675", "669", "670"
          name = Myp.appendstr(name, Myp.appendstrwrap("linoleic", "octadecadienoic")) + " acid"
        when "619"
          name = Myp.appendstr(name, Myp.appendstrwrap("linolenic", "octadecatrienoic")) + " acid"
        when "851"
          name = Myp.appendstr(name, Myp.appendstrwrap("alpha-linolenic", "octadecatrienoic")) + " acid"
        when "685"
          name = Myp.appendstr(name, Myp.appendstrwrap("gamma-linolenic", "octadecatrienoic")) + " acid"
        when "856"
          name = name + " octadecatrienoic acid"
        when "627"
          name = Myp.appendstr(name, Myp.appendstrwrap("parinaric", "octadecatetraenoic")) + " acid"
        when "672"
          name = name + " eicosadienoic acid"
        when "689", "852", "853"
          name = name + " eicosatrienoic acid"
        when "855"
          name = Myp.appendstr(name, Myp.appendstrwrap("arachidonic", "eicosatetraenoic")) + " acid"
        when "629"
          name = Myp.appendstr(name, Myp.appendstrwrap("timnodonic", "eicosapentaenoic (EPA)")) + " acid"
        when "631"
          name = Myp.appendstr(name, Myp.appendstrwrap("clupanodonic", "docosapentaenoic (DPA)")) + " acid"
        when "621"
          name = name + " docosahexaenoic (DHA) acid"
        end

        FoodNutrientInformation.create!(
          identity_id: User.current_user.primary_identity_id,
          nutrient_name: "#{name}",
          usda_nutrient_nutrient_number: nutrient.nutrient_number,
        )
      end
    end
  end
end
