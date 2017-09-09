require 'i18n'
require 'fileutils'
require 'github/markup'
require 'twilio-ruby'
require 'rest-client'
require 'time'
require 'posix/spawn'

module Myp
  
  DEFAULT_FROM_EMAIL = "contact"
  
  @@default_host = "myplaceonline.com"
  
  if !ENV["DEFAULT_HOST"].blank?
    @@default_host = ENV["DEFAULT_HOST"]
  end
  
  def self.default_host
    @@default_host
  end
  
  @@spawn_max_vsize = 302400
  
  if !ENV["SPAWN_MAX_VSIZE"].blank?
    @@spawn_max_vsize = ENV["SPAWN_MAX_VSIZE"]
  end
  
  def self.spawn_max_vsize
    @@spawn_max_vsize
  end
  
  def self.create_email(
    name: Myp::DEFAULT_FROM_EMAIL,
    host: nil,
    display: nil,
    display_prefix: nil,
    display_prefix_suffix: nil
  )
    if host.blank?
      host = MyplaceonlineExecutionContext.host
    end
    result = name + "@" + host
    if display.blank?
      display = host.camelize
    end
    if !display_prefix.blank? && !display_prefix_suffix.blank?
      display_prefix = display_prefix + " " + display_prefix_suffix
    end
    if !display.blank? && !display_prefix.blank?
      result = display_prefix.gsub(/[<@>]/, "") + " " + display.gsub(/[<@>]/, "") + " <" + result + ">"
    elsif !display.blank?
      result = display.gsub(/[<@>]/, "") + " <" + result + ">"
    elsif !display_prefix.blank?
      result = display_prefix.gsub(/[<@>]/, "") + " <" + result + ">"
    end
    result
  end
  
  FIELD_TEXT = :text
  FIELD_TEXT_AREA = :text_area
  FIELD_DATE = :date
  FIELD_DATETIME = :datetime
  FIELD_TIME = :time
  FIELD_NUMBER = :number
  FIELD_DECIMAL = :decimal
  FIELD_BOOLEAN = :boolean
  FIELD_SELECT = :select
  
  # We want at least 128 bits of randomness, so
  # min(POSSIBILITIES_*.length)^DEFAULT_PASSWORD_LENGTH should be >= 2^128
  DEFAULT_PASSWORD_LENGTH = 22
  
  # Avoid 1, l, o, O, 0, | characters to avoid ambiguity
  POSSIBILITIES_NUMERIC = [('1'..'9')].map { |i| i.to_a }.flatten
  POSSIBILITIES_LOWERCASE = [('a'..'k'), ('m'..'n'), ('p'..'z')].map { |i| i.to_a }.flatten
  POSSIBILITIES_UPPERCASE = [('A'..'N'), ('P'..'Z')].map { |i| i.to_a }.flatten
  POSSIBILITIES_SPECIAL = ['_', '-', '!']
  POSSIBILITIES_SPECIAL_ADDITIONAL = ['@', '$', '#', '%', '^', '&', '*', '(', ')', '[', ']', '+', '<', '>', '?', '/', ':', ';', ',', '=', '{', '}', '~']
  
  COOKIE_EXPIRATION = 1.year
  MAX_COOKIE_EXPIRES_DATE = DateTime.new(2038, 1, 1)
  
  DEFAULT_DECIMAL_STEP = "0.01"
  
  WEIGHTS = [
    ["myplaceonline.general.pounds", 0]
  ]
  
  FOOD_WEIGHT_POUNDS = 0
  FOOD_WEIGHT_CUPS = 1
  FOOD_WEIGHT_OUNCES = 2
  FOOD_WEIGHT_FLUID_OUNCES = 3
  FOOD_WEIGHT_MILLILITERS = 4
  FOOD_WEIGHT_GRAMS = 5
  
  FOOD_WEIGHTS = [
    ["myplaceonline.general.pounds", FOOD_WEIGHT_POUNDS],
    ["myplaceonline.general.cups", FOOD_WEIGHT_CUPS],
    ["myplaceonline.general.ounces", FOOD_WEIGHT_OUNCES],
    ["myplaceonline.general.fluid_ounces", FOOD_WEIGHT_FLUID_OUNCES],
    ["myplaceonline.general.milliliters", FOOD_WEIGHT_MILLILITERS],
    ["myplaceonline.general.grams", FOOD_WEIGHT_GRAMS]
  ]
  
  DIMENSIONS = [["myplaceonline.general.inches", 0]]
  LIQUID_CAPACITY = [["myplaceonline.general.gallons", 0]]
  VOLUMES = [["myplaceonline.general.cubicft", 0]]
  
  # For things like vitamins
  MEASUREMENTS = [
    ["myplaceonline.measurements.micrograms", 0],
    ["myplaceonline.measurements.ius", 1],
    ["myplaceonline.measurements.milligrams", 2]
  ]
  
  # For things like medicines
  DOSAGES = [
    ["myplaceonline.measurements.micrograms", 0],
    ["myplaceonline.measurements.ius", 1],
    ["myplaceonline.measurements.milligrams", 2]
  ]
  
  INTENSITIES = [
    ["myplaceonline.intensities.one", 1],
    ["myplaceonline.intensities.two", 2],
    ["myplaceonline.intensities.three", 3],
    ["myplaceonline.intensities.four", 4],
    ["myplaceonline.intensities.five", 5]
  ]
  
  LIQUID_CONCENTRATIONS = [
    ["myplaceonline.liquid_concentrations.mgperdl", 1],
    ["myplaceonline.liquid_concentrations.ratio", 2],
    ["myplaceonline.liquid_concentrations.mmoll", 3],
    ["myplaceonline.liquid_concentrations.gdl", 4],
    ["myplaceonline.liquid_concentrations.iul", 5],
    ["myplaceonline.liquid_concentrations.uiul", 6],
    ["myplaceonline.liquid_concentrations.ugdl", 7],
    ["myplaceonline.liquid_concentrations.percent", 8],
    ["myplaceonline.liquid_concentrations.ngdl", 9],
    ["myplaceonline.liquid_concentrations.ngml", 10],
    ["myplaceonline.liquid_concentrations.pgml", 11],
    ["myplaceonline.liquid_concentrations.number", 12],
    ["myplaceonline.liquid_concentrations.x10e3ul", 13],
    ["myplaceonline.liquid_concentrations.x10e6ul", 14],
    ["myplaceonline.liquid_concentrations.fL", 15],
    ["myplaceonline.liquid_concentrations.pg", 16],
    ["myplaceonline.liquid_concentrations.mlmin", 17],
    ["myplaceonline.liquid_concentrations.mgl", 18],
    ["myplaceonline.liquid_concentrations.mcgdl", 19],
    ["myplaceonline.liquid_concentrations.iuml", 20],
  ]

  TEMPERATURES = [
    ["myplaceonline.temperatures.fahrenheit", 0],
    ["myplaceonline.temperatures.celcius", 1]
  ]

  # DueItem.due_periodic_payments  
  PERIODS = [
    ["myplaceonline.periods.monthly", 0],
    ["myplaceonline.periods.yearly", 1],
    ["myplaceonline.periods.six_months", 2]
  ]
  
  MAX_RATING = 5
  
  RATINGS = [
    ["myplaceonline.ratings.zero", 0],
    ["myplaceonline.ratings.one", 1],
    ["myplaceonline.ratings.two", 2],
    ["myplaceonline.ratings.three", 3],
    ["myplaceonline.ratings.four", 4],
    ["myplaceonline.ratings.five", Myp::MAX_RATING]
  ]  
  
  NOISE_LEVELS = [
    ["myplaceonline.noise_levels.quiet", 0],
    ["myplaceonline.noise_levels.nature", 1],
    ["myplaceonline.noise_levels.mild", 2],
    ["myplaceonline.noise_levels.loud", 3],
    ["myplaceonline.noise_levels.very_loud", 4]
  ]
  
  PERIOD_TYPES = [
    ["myplaceonline.period_types.days", 0],
    ["myplaceonline.period_types.weeks", 1],
    ["myplaceonline.period_types.months", 2],
    ["myplaceonline.period_types.years", 10],
    ["myplaceonline.period_types.nth_monday", 3],
    ["myplaceonline.period_types.nth_tuesday", 4],
    ["myplaceonline.period_types.nth_wednesday", 5],
    ["myplaceonline.period_types.nth_thursday", 6],
    ["myplaceonline.period_types.nth_friday", 7],
    ["myplaceonline.period_types.nth_saturday", 8],
    ["myplaceonline.period_types.nth_sunday", 9]
  ]

  TIME_DURATION_SECONDS = 1
  TIME_DURATION_MINUTES = 2
  TIME_DURATION_HOURS = 4
  TIME_DURATION_DAYS = 8
  TIME_DURATION_WEEKS = 16
  TIME_DURATION_MONTHS = 32
  TIME_DURATION_YEARS = 64
  TIME_DURATION_NTH_MONDAY = 128
  TIME_DURATION_NTH_TUESDAY = 256
  TIME_DURATION_NTH_WEDNESDAY = 512
  TIME_DURATION_NTH_THURSDAY = 1024
  TIME_DURATION_NTH_FRIDAY = 2048
  TIME_DURATION_NTH_SATURDAY = 4096
  TIME_DURATION_NTH_SUNDAY = 8192
  TIME_DURATION_6MONTHS = 16384
  
  def self.period_type_to_repeat_type(period_type)
    case period_type
    when nil
      nil
    when 0
      Myp::TIME_DURATION_DAYS
    when 1
      Myp::TIME_DURATION_WEEKS
    when 2
      Myp::TIME_DURATION_MONTHS
    when 10
      Myp::TIME_DURATION_YEARS
    when 3
      Myp::TIME_DURATION_NTH_MONDAY
    when 4
      Myp::TIME_DURATION_NTH_TUESDAY
    when 5
      Myp::TIME_DURATION_NTH_WEDNESDAY
    when 6
      Myp::TIME_DURATION_NTH_THURSDAY
    when 7
      Myp::TIME_DURATION_NTH_FRIDAY
    when 8
      Myp::TIME_DURATION_NTH_SATURDAY
    when 9
      Myp::TIME_DURATION_NTH_SUNDAY
    else
      raise "TODO"
    end
  end
  
  def self.repeat_type_to_period_type(repeat_type)
    case repeat_type
    when nil
      nil
    when Myp::TIME_DURATION_DAYS
      0
    when Myp::TIME_DURATION_WEEKS
      1
    when Myp::TIME_DURATION_MONTHS
      2
    when Myp::TIME_DURATION_YEARS
      10
    when Myp::TIME_DURATION_NTH_MONDAY
      3
    when Myp::TIME_DURATION_NTH_TUESDAY
      4
    when Myp::TIME_DURATION_NTH_WEDNESDAY
      5
    when Myp::TIME_DURATION_NTH_THURSDAY
      6
    when Myp::TIME_DURATION_NTH_FRIDAY
      7
    when Myp::TIME_DURATION_NTH_SATURDAY
      8
    when Myp::TIME_DURATION_NTH_SUNDAY
      9
    else
      raise "TODO"
    end
  end

  def self.repeat_type_nth_to_wday(repeat_type)
    case repeat_type
    when nil
      nil
    when Myp::TIME_DURATION_NTH_SUNDAY
      0
    when Myp::TIME_DURATION_NTH_MONDAY
      1
    when Myp::TIME_DURATION_NTH_TUESDAY
      2
    when Myp::TIME_DURATION_NTH_WEDNESDAY
      3
    when Myp::TIME_DURATION_NTH_THURSDAY
      4
    when Myp::TIME_DURATION_NTH_FRIDAY
      5
    when Myp::TIME_DURATION_NTH_SATURDAY
      6
    else
      raise "TODO"
    end
  end
  
  def self.find_nth_weekday(year, month, wday, nth)
    x = Date.new(year, month, 1)
    found = false
    weekcount = 0
    while x.month == month
      if x.wday == wday
        weekcount = weekcount + 1
        if weekcount == nth
          found = true
          break
        end
      end
      x += 1.day
    end
    if found
      x
    else
      nil
    end
  end

  def self.period_to_repeat_type(period)
    case period
    when nil
      nil
    when 0
      Myp::TIME_DURATION_MONTHS
    when 1
      Myp::TIME_DURATION_YEARS
    when 2
      Myp::TIME_DURATION_6MONTHS
    else
      raise "TODO"
    end
  end
  
  def self.repeat_type_to_period(repeat_type)
    case repeat_type
    when nil
      nil
    when Myp::TIME_DURATION_MONTHS
      0
    when Myp::TIME_DURATION_YEARS
      1
    when Myp::TIME_DURATION_6MONTHS
      2
    else
      raise "TODO"
    end
  end
  
  def self.database_exists?
    begin
      ApplicationRecord.connection.data_source_exists?(Category.table_name)
    rescue ActiveRecord::NoDatabaseError
      false
    end
  end
  
  Rails.logger.info{"myplaceonline: myp.rb static initialization started"}
  
  Rails.logger.info{"Process pid: #{Process.pid}, ppid: #{Process.ppid}, uid: #{Process.uid}, gid: #{Process.gid}, argv: #{ARGV}"}
  
  def self.prepare_website_domain_html(html:)
    i = 0
    while true do
      match_data = html.match(/(<img.*)src=\"([^\"]+)\"/, i)
      if !match_data.nil?
        if match_data[2].index("://").nil?
          replacement = match_data[1] + "src=\"" + ActionController::Base.helpers.asset_path(match_data[2]) + "\""
          html = match_data.pre_match + replacement + match_data.post_match
          i = match_data.offset(0)[0] + replacement.length + 1
        else
          i = match_data.offset(0)[0] + match_data[0].length + 1
        end
      else
        break
      end
    end
    html
  end
  
  @@all_categories = Hash.new.with_indifferent_access
  @@all_categories_without_explicit_without_experimental = Hash.new.with_indifferent_access
  @@all_categories_without_explicit_with_experimental = Hash.new.with_indifferent_access
  @@all_categories_without_experimental_with_explicit = Hash.new.with_indifferent_access
  
  @@all_website_domains = Hash.new
  @@all_website_domain_homepages = Hash.new
  @@default_website_domain = nil

  # This may be called multiple times to re-initialize
  def self.reinitialize
    if Myp.database_exists?
      @@all_categories.clear
      @@all_categories_without_explicit_with_experimental.clear
      @@all_categories_without_experimental_with_explicit.clear
      @@all_categories_without_explicit_without_experimental.clear
      
      Category.all.each do |existing_category|
        is_explicit = existing_category.respond_to?("explicit?") && existing_category.explicit?
        is_experimental = existing_category.respond_to?("experimental?") && existing_category.experimental?

        @@all_categories[existing_category.name.to_sym] = existing_category
        @@all_categories_without_explicit_with_experimental[existing_category.name.to_sym] = existing_category
        @@all_categories_without_experimental_with_explicit[existing_category.name.to_sym] = existing_category
        @@all_categories_without_explicit_without_experimental[existing_category.name.to_sym] = existing_category
        
        if is_explicit
          @@all_categories_without_explicit_with_experimental.delete(existing_category.name.to_sym)
          @@all_categories_without_explicit_without_experimental.delete(existing_category.name.to_sym)
        end
        if is_experimental
          @@all_categories_without_experimental_with_explicit.delete(existing_category.name.to_sym)
          @@all_categories_without_explicit_without_experimental.delete(existing_category.name.to_sym)
        end
      end
      Rails.logger.info{"Myp: Categories cached: #{@@all_categories.count}"}
      if Rails.env.test?
        puts "Myp: Categories cached: #{@@all_categories.count}"
      end
      #puts "myplaceonline: Categories: " + @@all_categories.map{|k, v| v.nil? ? "#{k} = nil" : "#{k} = #{v.id}/#{v.name.to_s}" }.inspect
      
      self.reinitialize_in_rails_context
    end
  end
  
  def self.reinitialize_in_rails_context
    if Myp.database_exists?
      begin
        @@default_website_domain = nil
        @@all_website_domains.clear
        @@all_website_domain_homepages.clear
        WebsiteDomain.where(verified: true).each do |website_domain|
          if !website_domain.hosts.blank?
            if website_domain.default_domain
              @@default_website_domain = website_domain
            end
            
            html = website_domain.static_homepage

            if !html.blank?
              html = self.prepare_website_domain_html(html: html)
            end
            
            #Rails.logger.debug{"Homepage for #{website_domain.display}:\n#{html}"}
            
            website_domain.hosts.split(",").each do |matching_host|
              if !matching_host.blank?
                @@all_website_domains[matching_host] = website_domain
                @@all_website_domain_homepages[matching_host] = html
              end
            end
          end
        end
      rescue ActiveRecord::StatementInvalid
        # Mid-migration
      end

      Rails.logger.info{"Myp: Website domains cached: #{@@all_website_domains.count}"}
      if Rails.env.test?
        puts "Myp: Website domains cached: #{@@all_website_domains.count}"
      end
    end
  end
  
  self.reinitialize
  
  if !ENV["FTS_TARGET"].blank?
    Rails.logger.info{"Configuring full text search with #{ENV["FTS_TARGET"]}"}
    Chewy.root_strategy = :active_job
    Chewy.settings = {host: ENV["FTS_TARGET"]}
  end
  
  if !ENV["TRUSTED_CLIENTS"].blank?
    @@trusted_client_ips = ENV["TRUSTED_CLIENTS"].split(";").map{|trusted_client| Socket.getaddrinfo(trusted_client, nil, :INET)[0][2] }
    Rails.logger.info{"Trusted client IPs: #{@@trusted_client_ips} from #{ENV["TRUSTED_CLIENTS"].split(";")}"}
  else
    @@trusted_client_ips = []
    Rails.logger.info{"No trusted client IPs"}
  end
  
  def self.trusted_client_ips
    @@trusted_client_ips
  end

  if !ENV["GOOGLE_MAPS_API_KEY"].blank?
    @@google_maps_api_key = ENV["GOOGLE_MAPS_API_KEY"]
    Rails.logger.info{"Found Google Maps API key"}
  end
  
  def self.google_maps_api_key
    @@google_maps_api_key
  end

  def self.categories(user = nil)
    if user.nil?
      @@all_categories
    else
      if user.explicit_categories && !user.experimental_categories
        @@all_categories_without_experimental_with_explicit
      elsif !user.explicit_categories && user.experimental_categories
        @@all_categories_without_explicit_with_experimental
      elsif !user.explicit_categories && !user.experimental_categories
        @@all_categories_without_explicit_without_experimental
      else
        @@all_categories
      end
    end
  end
  
  def self.current_host(host: nil)
    if host.blank?
      host = MyplaceonlineExecutionContext.host
    end
    
    host
  end
  
  def self.website_domain(host: nil)
    
    result = @@all_website_domains[Myp.current_host(host: host)]
    
    if result.nil?
      result = @@default_website_domain
    end
    
    result
  end

  def self.website_domain_homepage(host: nil)
    host = Myp.current_host(host: host)
    result = @@all_website_domain_homepages[host]
    if result.blank?
      website_domain = self.website_domain(host: host)
      Rails.logger.debug{"Myp.website_domain_homepage initializing domain #{host}"}
      if !website_domain.homepage_path.blank?
        Rails.logger.debug{"Myp.website_domain_homepage processing #{website_domain.homepage_path}"}
        params = {}
        pieces = website_domain.homepage_path.split("/")
        i = pieces.length - 1
        save_id = nil
        action = nil
        last_controller = nil
        while i >= 0
          piece = pieces[i]
          if Myp.is_number?(piece)
            if params.length == 0
              params["id"] = piece
            else
              save_id = piece
            end
          else
            Rails.logger.debug{"Myp.website_domain_homepage piece: #{piece}, params: #{params.length}"}
            if last_controller.nil? && params.length == 1
              last_controller = piece
            else
              if !save_id.nil?
                params[piece.singularize + "_id"] = save_id
                save_id = nil
              else
                if action.nil?
                  action = piece.to_sym
                end
              end
            end
          end
          i = i - 1
        end
        if action.blank?
          action = :show
        end
        params[:no_layout] = true
        controller_class = Object.const_get(last_controller.camelize + "Controller")
        Rails.logger.debug{"Myp.website_domain_homepage rendering controller: #{controller_class}, action: #{action}, params: #{params.inspect}"}
        obj = Object.const_get(last_controller.camelize.singularize).send("find", params["id"])
        
        if website_domain.homepage_path_cached
          MyplaceonlineExecutionContext.do_ability_identity(obj.identity) do
            result = Myp.renderActionInOtherController(controller_class, action, params)
          end
          result = self.prepare_website_domain_html(html: result)
          Rails.logger.debug{"Myp.website_domain_homepage html: #{result}"}
        else
          result = {
            obj: obj,
            controller_class: controller_class,
            action: action,
            params: params,
          }
        end
        
        @@all_website_domain_homepages[host] = result
      end
    end
    result
  end

  # Return a list of ListItemRow objects.
  # Assumes user is logged in.
  #
  # If parent is nil, search for all categories.
  # If parent is -1, search for all root categories.
  # Parent is is >= 0, search for all categories with a particular parent.
  def self.categories_for_current_user(user, parent = nil, orderByName = false)
    # We want a set of categories, left outer joined with points for each of
    # those for the current user, if available.
    #
    # Ideally we would use something like:
    #
    # Category.where(parent: nil).order(:position)
    #   .includes(:category_points_amounts)
    #   .where(category_points_amounts:
    #     {identity: user.primary_identity}
    #   )
    #
    # However, this places the where clause at the end instead of as an addition
    # to the LEFT OUTER JOIN clause, so we only get categories if the identity
    # has points for them.
    # 
    # Instead we could do a joins() call with an explicit LEFT OUTER JOIN and
    # the additional identity condition, but then we don't eager load the point
    # amounts, and if we go and get the point amounts, it won't go with the
    # identity condition.
    #
    # Therefore we have to fallback to direct SQL.

    # The first set of where clauses is to check that either the category has
    # no required user type mask, or if it has one, first whether the user has
    # a type mask (otherwise, there's no point in checking), and if so, if
    # the category mask is subsumed in the user mask
    where_clause = "WHERE (categories.user_type_mask IS NULL"
    if !user.user_type.nil?
      where_clause += " OR (" + user.user_type.to_s + " & categories.user_type_mask != 0)"
    end
    where_clause += ")"
    
    if !parent.nil?
      if parent == -1
        where_clause += " AND categories.parent_id IS NULL"
      else
        where_clause += " AND categories.parent_id = " + parent.id.to_s
      end
    end

    # By default, we don't show explicit categories
    explicit_check = Myp.get_categories_check_sql(user)
    if explicit_check.length > 0
      where_clause += " AND " + explicit_check
    end
    
    Category.find_by_sql(%{
      SELECT categories.*, category_points_amounts.count as points_amount
      FROM categories
      LEFT OUTER JOIN category_points_amounts
        ON category_points_amounts.category_id = categories.id
            AND category_points_amounts.identity_id = #{
                ActiveRecord::Base.connection.quote(user.primary_identity.id)
              }
      #{ where_clause }
      ORDER BY #{
        orderByName ?
          "categories.name ASC" :
          "categories.position ASC, categories.name ASC"
      }
    }).map{ |category|
      ListItemRow.new(
        category.human_title,
        "/" + category.link,
        category.points_amount.nil? ? 0 : category.points_amount,
        category.id,
        category.parent_id,
        category.filtertext,
        category.icon,
        category.simple ? nil : category.category_split_button_link,
        category.simple ? nil : category.category_split_button_title,
        category.simple ? nil : category.category_split_button_icon,
      )
    }
  end
  
  def self.get_categories_check_sql(user)
    if !user.explicit_categories && !user.experimental_categories
      "(categories.explicit IS NULL AND categories.experimental IS NULL)"
    elsif user.explicit_categories && !user.experimental_categories
      "(categories.experimental IS NULL)"
    elsif !user.explicit_categories && user.experimental_categories
      "(categories.explicit IS NULL)"
    else
      ""
    end
  end
  
  def self.useful_categories(user, recentlyVisited = 2, mostVisited = 3)
    # Prefer last visit over number of visits
    
    explicit_check = Myp.get_categories_check_sql(user)
    
    if explicit_check.length > 0
      explicit_check += " AND "
    end
    
    CategoryPointsAmount.find_by_sql(%{
      (
        SELECT category_points_amounts.*, categories.name as category_name, categories.icon as category_icon, categories.additional_filtertext as category_additional_filtertext, categories.link as category_link, categories.parent_id as category_parent_id, 0 as select_type, categories.simple as category_simple
        FROM category_points_amounts
        INNER JOIN categories ON category_points_amounts.category_id = categories.id
        WHERE category_points_amounts.last_visit IS NOT NULL AND #{ explicit_check } categories.parent_id IS NOT NULL AND category_points_amounts.identity_id = #{
                ActiveRecord::Base.connection.quote(user.primary_identity.id)
              }
        ORDER BY category_points_amounts.last_visit DESC
        LIMIT #{ recentlyVisited }
      )
      UNION ALL
      (
        SELECT category_points_amounts.*, categories.name as category_name, categories.icon as category_icon, categories.additional_filtertext as category_additional_filtertext, categories.link as category_link, categories.parent_id as category_parent_id, 1 as select_type, categories.simple as category_simple
        FROM category_points_amounts
        INNER JOIN categories ON category_points_amounts.category_id = categories.id
        WHERE category_points_amounts.visits IS NOT NULL AND #{ explicit_check } categories.parent_id IS NOT NULL AND category_points_amounts.identity_id = #{
                ActiveRecord::Base.connection.quote(user.primary_identity.id)
              }
        ORDER BY category_points_amounts.visits DESC
        LIMIT #{ mostVisited }
      )
    })
    .uniq{ |cpa| cpa.category_id }.map{ |cpa|
      ListItemRow.new(
        Category.human_title(cpa.category_name),
        "/" + cpa.category_link,
        cpa.count.nil? ? 0 : cpa.count,
        cpa.category_id,
        cpa.category_parent_id,
        Category.filtertext(cpa.category_name, cpa.category_additional_filtertext),
        cpa.category_icon,
        cpa.category_simple ? nil : "/" + cpa.category_link + "/new",
        cpa.category_simple ? nil : I18n.t("myplaceonline.general.add")
      )
    }
  end

  class ListItemRow
    def initialize(title, link, count = nil, id = nil, parent_id = nil, filtertext = nil, icon = nil, splitLink = nil, splitLinkTitle = nil, splitLinkButton = nil)
      @title = title
      @link = link
      @count = count
      @id = id
      @parent_id = parent_id
      @filtertext = filtertext
      if !icon.nil?
        @icon = ActionController::Base.helpers.asset_path(icon, type: :image)
      else
        @icon = nil
      end
      @splitLink = splitLink
      @splitLinkTitle = splitLinkTitle
      @splitLinkButton = splitLinkButton
    end
    
    def title
      @title
    end
    
    def link
      @link
    end
    
    def count
      @count
    end
    
    def id
      @id
    end
    
    def parent_id
      @parent_id
    end
    
    def filtertext
      @filtertext
    end
    
    def icon
      @icon
    end
    
    def splitLink
      @splitLink
    end
    
    def splitLinkTitle
      @splitLinkTitle
    end
    
    def splitLinkButton
      @splitLinkButton
    end
  end

  def self.markdown_to_html(markdown)
    if !markdown.nil?
      GitHub::Markup.render_s(GitHub::Markups::MARKUP_MARKDOWN, markdown)
    else
      nil
    end
  end
  
  def self.markdown_for_plain_email(markdown)
    if !markdown.nil?
      i = 0
      while true do
        match_data = markdown.match(/\[([^\]]+)\]\(([^)]+)\)/, i)
        if !match_data.nil?
          if match_data[1] == match_data[2]
            replacement = match_data[1]
          else
            replacement = match_data[1] + " (" + match_data[2] + ")"
          end
          markdown = match_data.pre_match + replacement + match_data.post_match
          i = match_data.offset(0)[0] + replacement.length + 1
        else
          break
        end
      end
      markdown
    else
      nil
    end
  end
  
  def self.parse_yaml_to_html(id)
    str = I18n.t(id)
    xml = Nokogiri::XML("<xml>#{str}</xml>")
    cdata = xml.root.xpath("//xml").children.find{|e| e.cdata?}
    if !cdata.nil?
      markdown_to_html(cdata.text.strip)
    else
      raise "nil CDATA for #{xml}"
    end
  end
  
  def self.is_web_server?
    defined?(Rails::Server) || defined?(::PhusionPassenger)
  end
  
  def self.persist_password(password)
    MyplaceonlineExecutionContext.persistent_user_store[:password] = password
    if !User.current_user.nil? && User.current_user.pending_encryption_switch
      ApplicationJob.perform(SwitchUserEncryptionJob, User.current_user, password)
    end
  end
  
  def self.get_current_user_password!
    result = MyplaceonlineExecutionContext.persistent_user_store[:password]
    if result.nil?
      raise Myp::DecryptionKeyUnavailableError
    end
    result
  end
  
  def self.encrypt_with_user_password!(user, message)
    self.encrypt(user, message, self.get_current_user_password!)
  end
  
  def self.encrypt(user, message, key)
    result = EncryptedValue.new
    self.encrypt_value(user, message, key, result)
  end
  
  def self.map_cipher(encryption_mode)
    case encryption_mode
    when Myp::ENCRYPTION_MODE_AES_256_GCM
      result = "aes-128-gcm"
    when Myp::ENCRYPTION_MODE_AES_256_CBC
      result = "aes-256-cbc"
    else
      raise "TODO"
    end
    result
  end
  
  def self.encrypt_value(user, message, key, value)
    if !message.nil? && !message.kind_of?(String)
      message = Myp.eye_catcher_marshalled + Marshal::dump(message)
    end
    # TODO OpenSSL::Cipher.update does not allow a nil or empty value
    if message.nil? || message == "" then
      message = " "
    end
    if user.nil?
      raise Myp::UserUnavailableError
    end
    value.encryption_type = user.get_encryption_mode
    value.user = user
    
    cipher = Myp.map_cipher(value.encryption_type)
    
    # https://github.com/digitalbazaar/forge/issues/207
    cipher_key_length = OpenSSL::Cipher.new(cipher).key_len
    
    # OpenSSL only uses an 8 byte salt: https://www.openssl.org/docs/crypto/EVP_BytesToKey.html
    # "The standard recommends a salt length of at least [8 bytes]." (http://en.wikipedia.org/wiki/PBKDF2)
    # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/message_encryptor.rb
    value.salt = SecureRandom.random_bytes(64)
    
    # This uses PBKDF2+HMAC+SHA1 with an iteration count of 65536:
    # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/key_generator.rb
    generated_key = ActiveSupport::KeyGenerator.new(key).generate_key(value.salt, cipher_key_length)
    
    # https://github.com/rails/rails/blob/master/activesupport/lib/active_support/message_encryptor.rb
    crypt = ActiveSupport::MessageEncryptor.new(
      generated_key,
      cipher: cipher,
      serializer: SimpleSerializer.new
    )
    
    value.val = crypt.encrypt_and_sign(message)
    
    value
  end
  
  def self.copy_encrypted_value_attributes(source, destination)
    destination.encryption_type = source.encryption_type
    destination.salt = source.salt
    destination.val = source.val
  end
  
  def self.decrypt_with_user_password!(encrypted_value)
    if encrypted_value.nil?
      raise Myp::EncryptedValueUnavailableError
    end
    self.decrypt(encrypted_value, self.get_current_user_password!)
  end
  
  def self.decrypt(encrypted_value, key)
    cipher = Myp.map_cipher(encrypted_value.encryption_type)
    
    cipher_key_length = OpenSSL::Cipher.new(cipher).key_len
    
    generated_key = ActiveSupport::KeyGenerator.new(key).generate_key(encrypted_value.salt, cipher_key_length)
    
    crypt = ActiveSupport::MessageEncryptor.new(
      generated_key,
      cipher: cipher,
      serializer: SimpleSerializer.new
    )
    
    result = crypt.decrypt_and_verify(encrypted_value.val)
    
    if !result.nil?
      result.force_encoding("utf-8")
    end
    
    if result.start_with?(Myp.eye_catcher_marshalled)
      result = Marshal::load(result[Myp.eye_catcher_marshalled.length..-1])
    end
    
    result
  end
  
  def self.password_changed(user, old_password, new_password)
    if !old_password.eql?(new_password)
      ApplicationJob.perform(UpdateUserPasswordJob, user, old_password, new_password)
    end
  end
  
  def self.visit(user, categoryName)
    category = Myp.categories(user)[categoryName]
    if category.nil?
      raise "Could not find category " + categoryName + " (check Myp.website_init)"
    end
    cpa = CategoryPointsAmount.find_or_create_by(
      identity: user.primary_identity,
      category: category
    )
    if cpa.visits.nil?
      cpa.visits = 0
    end
    cpa.visits += 1
    cpa.last_visit = DateTime.now
    cpa.save
  end
  
  def self.add_point(user, categoryName, session = nil)
    self.modify_points(user, categoryName, 1, session)
  end
  
  def self.subtract_point(user, categoryName, session = nil)
    self.modify_points(user, categoryName, -1, session)
  end
  
  def self.modify_points(user, categoryName, amount, session = nil)
    ApplicationRecord.transaction do
      
      if user.primary_identity.points.nil?
        user.primary_identity.points = 0
      end
      user.primary_identity.points += amount
      if user.primary_identity.points < 0
        user.primary_identity.points = 0
      end
      
      # Don't use the normal ActiveRecord update mechanism because that
      # will fire commit hooks which for Identity will re-do calendar
      # entries
      #user.primary_identity.save
      ApplicationRecord.connection.update("update identities set points = #{user.primary_identity.points} where id = #{user.primary_identity.id}")
      
      category = Myp.categories(user)[categoryName]
      if category.nil?
        raise "Could not find category " + categoryName + " (check Myp.website_init)"
      end
      
      while !category.nil? do
        cpa = CategoryPointsAmount.find_or_create_by(
          identity: user.primary_identity,
          category: category
        )
        if cpa.count.nil?
          cpa.count = 0
        end
        cpa.count += amount
        if cpa.count < 0
          if !Rails.env.test?
            #Myp.warn("Something went wrong, category count would go negative for #{category.inspect}")
          end
          break
        end
        cpa.save
        category = category.parent
      end
    end
    
    if !session.nil?
      if session[:points_flash].nil?
        session[:points_flash] = amount
      else
        session[:points_flash] = session[:points_flash] + amount
      end
    end
  end
  
  def self.clear_points_flash(session)
    if !session.nil?
      session[:points_flash] = nil
    end
  end
  
  def self.warn(message, exception = nil)
    subject = "Myplaceonline Warning"
    body_plain = message
    body_html = CGI::escapeHTML(message)
    if !exception.nil?
      error_details = Myp.error_details(exception)
      body_plain += "\n\n" + error_details
      body_html += "\n\n<p>" + CGI::escapeHTML(error_details).gsub(/\n/, "<br />\n").gsub(/\t/, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;") + "</p>"
      #subject += " (#{exception.class})"
    end
    if !ENV["NODENAME"].blank?
      body_plain += "\n\nServer: #{ENV["NODENAME"]}"
      body_html += "\n\n<p>Server: #{ENV["NODENAME"]}</p>"
    end
    Rails.logger.warn{"Myp.warn: #{message}"}
    Myp.send_support_email_safe(subject, body_html.html_safe, body_plain)
  end
  
  def self.reset_points(user)
    ApplicationRecord.transaction do
      user.primary_identity.points = 0
      user.primary_identity.save
      
      CategoryPointsAmount.where(identity: user.primary_identity).update_all(count: 0)
    end
  end

  def self.reentry_url(request)
    if request.query_parameters.length == 0
      "/users/reenter?redirect=" + URI.encode(request.path)
    else
      "/users/reenter?redirect=" + URI.encode(request.path + "?" + request.query_parameters.to_a.map{|x| x[0].to_s + "=" + x[1].to_s }.join("&"))
    end
  end
  
  def self.error_details(error)
    error.inspect + "\n\t" + error.backtrace.join("\n\t")
  end
  
  def self.current_stack
    begin
      raise "Benign"
    rescue Exception => e
      e.backtrace.join("\n\t")
    end
  end
  
  def self.log_error(logger, error)
    logger.error(self.error_details(error))
  end
  
  class DecryptionKeyUnavailableError < StandardError; end
  class UserUnavailableError < StandardError; end
  class EncryptedValueUnavailableError < StandardError; end
  class SessionUnavailableError < StandardError; end
  class CannotFindNestedAttribute < StandardError; end

  class SimpleSerializer
    def dump(value)
      value
    end
    
    def load(value)
      value
    end
  end
  
  def self.select_listitem(selector)
    "$(this).addClass('ui-btn-active'); $('" + selector + "').val(myplaceonline.objectExtractId(this)); return false;"
  end
  
  def self.display_date(time, current_user)
    self.display_time(time, current_user, :simple_date)
  end
  
  def self.display_datetime(time, current_user)
    self.display_time(time, current_user, :default)
  end
  
  def self.display_date_short(time, current_user)
    self.display_time(time, current_user, :short_date)
  end
  
  def self.display_date_short_year(time, current_user)
    self.display_time(time, current_user, :short_date_year)
  end
  
  def self.display_date_month_year(time, current_user)
    self.display_time(time, current_user, :month_year)
  end
  
  def self.display_date_month_year_simple(time, current_user)
    self.display_time(time, current_user, :month_year_simple)
  end
  
  def self.display_datetime_short(time, current_user)
    self.display_time(time, current_user, :short_datetime)
  end
  
  def self.display_datetime_short_year(time, current_user)
    self.display_time(time, current_user, :short_datetime_year)
  end
  
  def self.display_time(time, current_user, format = :default)
    if !time.nil?
      if !current_user.nil? && !current_user.timezone.blank?
        time = time.in_time_zone(current_user.timezone)
      else
        time = time.in_time_zone(Rails.application.config.time_zone)
      end
      if !time.nil?
        time.to_s(format)
      else
        nil
      end
    else
      nil
    end
  end
  
  def self.display_currency(obj, current_user = nil)
    if !obj.blank?
      self.number_to_currency(obj)
    else
      nil
    end
  end

  def self.eye_catcher_marshalled
    "M4RSH4LLED_"
  end
  
  def self.time_difference_in_general_from_date(time, from)
    diff = TimeDifference.between(from, time)
    Myp.time_difference_in_general_human(diff.in_general)
  end
  
  def self.time_difference_in_general_from_now(time)
    diff = TimeDifference.between(Time.now, time)
    Myp.time_difference_in_general_human(diff.in_general)
  end
  
  def self.time_difference_in_general_human(diff)
    result = ""
    if diff[:years] > 0
      result += ActionController::Base.helpers.pluralize(diff[:years], "year")
    end
    if diff[:months] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(diff[:months], "month")
    end
    if diff[:weeks] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(diff[:weeks], "week")
    end
    if diff[:days] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(diff[:days], "day")
    end
    if result.length == 0
      if diff.values.reduce(:+) == 0
        result += I18n.t("myplaceonline.general.today")
      elsif diff[:hours] > 0
        result += ActionController::Base.helpers.pluralize(diff[:hours], "hour")
      end
    end
    if result.blank?
      result = time_difference_in_general_human_detailed_hms(diff, result)
    end
    result
  end
  
  def self.time_difference_in_general_human_detailed_from_now(dt)
    time_difference_in_general_human_detailed(TimeDifference.between(dt, Time.now).in_general)
  end
  
  def self.time_difference_in_general_human_detailed(diff)
    result = Myp.time_difference_in_general_human(diff)
    result = Myp.time_difference_in_general_human_detailed_hms(diff, result)
    result
  end
  
  def self.seconds_to_time_in_general_human_detailed_hms(seconds)
    if !seconds.nil?
      diff = {
        hours: 0,
        minutes: 0,
        seconds: 0
      }
      if seconds >= 3600
        diff[:hours] = (seconds / 3600).to_i
        seconds = seconds % 3600
      end
      if seconds >= 60
        diff[:minutes] = (seconds / 60).to_i
        seconds = seconds % 60
      end
      diff[:seconds] = seconds
      Myp.time_difference_in_general_human_detailed_hms(diff, "")
    else
      nil
    end
  end
  
  def self.time_difference_in_general_human_detailed_hms(diff, result)
    if diff[:hours] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(Myp.decimal_to_s(value: diff[:hours]), "hour")
    end
    if diff[:minutes] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(Myp.decimal_to_s(value: diff[:minutes]), "minute")
    end
    if diff[:seconds] > 0
      if result.length > 0
        result += ", "
      end
      result += ActionController::Base.helpers.pluralize(Myp.decimal_to_s(value: diff[:seconds]), "second")
    end
    result
  end
  
  # We don't actually pass in params to new() because that will cause
  # a ForbiddenAttributesError. They may be set separately using
  # assign_attributes. The params are just passed in so that the model
  # has a chance to access form values
  def self.new_model(model, params = nil)
    if model.respond_to?("build")
      result = model.build(params)
    else
      result = model.new(params)
    end
    current_user = User.current_user
    if !current_user.nil? && result.respond_to?("identity_id=")
      result.identity_id = current_user.primary_identity.id
    end
    result
  end
  
  def self.get_select_name(val, select_values, default_value: nil)
    if !val.nil?
      found = select_values.find{|x| x[1] == val}
      if !found.nil?
        I18n.t(found[0])
      else
        default_value
      end
    else
      default_value
    end
  end

  def self.translate_options(options, sort: false)
    result = options.map{|o| [I18n.t(o[0]), o[1]]}
    if sort
      result = result.sort_by{|x| x[0]}
    end
    result
  end
  
  def self.includes_today?(start_date, end_date)
    Myp.includes_date?(DateTime.now, start_date, end_date)
  end
  
  def self.includes_date?(the_date, start_date, end_date)
    if start_date.nil? && end_date.nil?
      true
    elsif start_date.nil?
      if the_date <= end_date
        true
      else
        false
      end
    elsif end_date.nil?
      if the_date >= start_date
        true
      else
        false
      end
    else
      if the_date >= start_date && the_date <= end_date
        true
      else
        false
      end
    end
  end

  def self.truncate_zeros(str)
    str.gsub("\.0", "")
  end
  
  def self.use_html5_inputs()
    true
  end
  
  def self.is_ios
    MyplaceonlineExecutionContext.browser.nil? ? false : MyplaceonlineExecutionContext.browser.platform.ios?
  end
  
  def self.use_html5_date_inputs()
    false
  end
  
  def self.number_to_currency(x)
    ActionController::Base.helpers.number_to_currency(x)
  end
  
  def self.number_with_delimiter(x)
    ActionController::Base.helpers.number_with_delimiter(x)
  end
  
  def self.decimal_to_s(value:, precision: 2, truncate_zeros: true)
    result = sprintf("%.#{precision}f", value.round(precision))
    if result.end_with?("00")
      result = result[0..result.length-4]
    end
    result
  end
  
  def self.migration_add_filtertext(category_name, filtertext)
    category = Category.where(name: category_name).first
    if category.nil?
      raise "Category not found"
    end
    if category.additional_filtertext.blank?
      category.additional_filtertext = filtertext
      puts "Set filtertext to #{filtertext}"
    else
      category.additional_filtertext += " " + filtertext
      puts "Updated filtertext to #{category.additional_filtertext}"
    end
    category.save!
  end
  
  def self.migration_set_icon(category_name, icon)
    category = Category.where(name: category_name).first
    if category.nil?
      raise "Category not found"
    end
    category.icon = icon
    puts "Set icon to #{icon}"
    category.save!
  end
  
  def self.appendstr(str, what, delimeter = " ", leftwrap = nil, rightwrap = nil)
    if !what.blank?
      what = what.to_s
      if str.blank?
        str = ""
      else
        if !delimeter.nil?
          str += delimeter
        end
      end
      if !leftwrap.nil?
        str += leftwrap
      end
      str += what
      if !rightwrap.nil?
        str += rightwrap
      end
    end
    str
  end
  
  def self.appendstrwrap(str, what)
    Myp.appendstr(str, what, nil, " (", ")")
  end
  
  def self.alternative_if_blank(str, what_to_set)
    str.blank? ? what_to_set : str
  end
  
  def self.query_parameters_uri_part(request, excludes = [])
    request.query_parameters().dup.delete_if{|k,v| !excludes.index(k.to_sym).nil? || (!v.is_a?(String) && !v.is_a?(Symbol)) }.map{|k,v| URI.encode(k) + "=" + URI.encode(v)}.join("&")
  end

  PAGE_TRANSITIONS = [
    ["myplaceonline.page_transitions.none", 0],
    ["myplaceonline.page_transitions.fade", 1],
    ["myplaceonline.page_transitions.pop", 2],
    ["myplaceonline.page_transitions.flip", 3],
    ["myplaceonline.page_transitions.turn", 4],
    ["myplaceonline.page_transitions.flow", 5],
    ["myplaceonline.page_transitions.slidefade", 6],
    ["myplaceonline.page_transitions.slide", 7],
    ["myplaceonline.page_transitions.slideup", 8],
    ["myplaceonline.page_transitions.slidedown", 9]
  ]
  
  def self.page_transition_value_to_jqm(x)
    if x == 0
      "none"
    elsif x == 1
      "fade"
    elsif x == 2
      "pop"
    elsif x == 3
      "flip"
    elsif x == 4
      "turn"
    elsif x == 5
      "flow"
    elsif x == 6
      "slidefade"
    elsif x == 7
      "slide"
    elsif x == 8
      "slideup"
    elsif x == 9
      "slidedown"
    else
      nil
    end
  end
  
  ENCRYPTION_MODE_AES_256_GCM = 0
  ENCRYPTION_MODE_AES_256_CBC = 1
  
  # TODO http://stackoverflow.com/questions/42774930/how-do-i-use-aes-128-gcm-encryption-in-rails
  ENCRYPTION_MODE_DEFAULT = ENCRYPTION_MODE_AES_256_CBC
  
  ENCRYPTION_MODES = [
    # ["myplaceonline.encryption_modes.aes_256_gcm", ENCRYPTION_MODE_AES_256_GCM],
    ["myplaceonline.encryption_modes.aes_256_cbc", ENCRYPTION_MODE_AES_256_CBC],
  ]
  
  AFTER_NEW_ITEM_SHOW_ITEM = 0
  AFTER_NEW_ITEM_SHOW_LIST = 1
  AFTER_NEW_ITEM_ANOTHER_ITEM = 2
  
  AFTER_NEW_ITEM_LIST = [
    ["myplaceonline.after_new_item.show_item", AFTER_NEW_ITEM_SHOW_ITEM],
    ["myplaceonline.after_new_item.show_list", AFTER_NEW_ITEM_SHOW_LIST],
    ["myplaceonline.after_new_item.another_item", AFTER_NEW_ITEM_ANOTHER_ITEM],
  ]
  
  CLIPBOARD_INTEGRATIONS = [
    ["myplaceonline.clipboard.none", 0],
    ["myplaceonline.clipboard.zeroclipboard", 1],
    ["myplaceonline.clipboard.ffclipboard", 2]
  ]
  
  def self.images_for_points(points)
    if !points.nil?
      if points == 42
        ActionController::Base.helpers.link_to "/badges/" + points.to_s do
          ActionController::Base.helpers.image_tag("FatCow_Icons16x16/hhg.png", height: "16", width: "16", alt: I18n.t("myplaceonline.points_image.n" + points.to_s), title: I18n.t("myplaceonline.points_image.n" + points.to_s))
        end
      else
        nil
      end
    else
      nil
    end
  end
  
  def self.set_existing_object(targetobj, targetname, model, id, action: :edit)
    if model.nil?
      model = Object.const_get(targetname.to_s.camelize)
    end
    if model.new.respond_to?("identity_id")
      obj = model.find_by(
        id: id,
        identity: Permission.current_target_identity
      )
      if obj.nil?
        authorization_object = model.find(id)
        if Ability.authorize(identity: Permission.current_target_identity, subject: authorization_object, action: action)
          obj = authorization_object
        end
      end
    else
      obj = model.find(id)
    end
    if obj.nil?
      raise "Could not find " + model.to_s + " with ID " + id.to_s
    end
    targetobj.send(
      "#{targetname.to_s}=",
      obj
    )
    obj
  end
  
  def self.find_existing_object(class_name, id, use_security = true)
    if use_security
      Object.const_get(class_name.to_s.camelize).find_by(
        id: id,
        identity: Permission.current_target_identity
      )
    else
      Object.const_get(class_name.to_s.camelize).find_by(
        id: id
      )
    end
  end
  
  def self.find_existing_object!(class_name, id)
    Object.const_get(class_name.to_s.camelize).find_by(
      id: id
    )
  end
  
  def self.process_headers(request)
    request.headers.env.dup.delete_if{| key, value |
      (!key.start_with?("HTTP_") && 
      !key.start_with?("SCRIPT_") && 
      !key.start_with?("PATH_") && 
      !key.start_with?("REQUEST_") && 
      !key.start_with?("SERVER_") && 
      !key.start_with?("QUERY_") && 
      !key.start_with?("RAILS_") && 
      !key.start_with?("REMOTE_") && 
      !key.start_with?("WEB_") && 
      !key.start_with?("ORIGINAL_")) || key.start_with?("HTTP_COOKIE")
    }.to_a.map{|kv| "#{kv[0]}: #{kv[1]}"}.join("\n\t")
  end
  
  def self.handle_exception(exception, email = nil, request = nil, subject = "User Exception")
    body_plain = ""
    body_html = ""
    
    if !email.blank?
      body_html += "<p>User: #{email}</p>".html_safe
      body_plain += "User: #{email}"
    end

    if !exception.nil?
      error_details = Myp.error_details(exception)
      body_plain += "\n\n" + error_details
      body_html += "\n\n<p>" + CGI::escapeHTML(error_details).gsub(/\n/, "<br />\n").gsub(/\t/, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;") + "</p>"
    end

    if !request.nil?
      str = "Request: {" +
          "\n\tfullpath: #{request.fullpath.inspect}, " +
          "\n\tip: #{request.ip.inspect}, " +
          "\n\tmethod: #{request.method.inspect}, " +
          "\n\toriginal_fullpath: #{request.original_fullpath.inspect}, " +
          "\n\toriginal_url: #{request.original_url.inspect}, " +
          "\n\tquery_parameters: #{request.query_parameters.inspect}, " +
          "\n\tremote_ip: #{request.remote_ip.inspect}, " +
          "\n\trequest_method: #{request.request_method.inspect}, " +
          "\n\tuuid: #{request.uuid.inspect}" +
          "\n}"
      
      body_plain += "\n\n" + str
      body_html += "\n\n<p>" + CGI::escapeHTML(str).gsub(/\n/, "<br />\n").gsub(/\t/, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;") + "</p>"
      
      headers = request.headers
      if !headers.nil?
        str = "Headers: {\n\t#{self.process_headers(request)}\n}"

        body_plain += "\n\n" + str
        body_html += "\n\n<p>" + CGI::escapeHTML(str).gsub(/\n/, "<br />\n").gsub(/\t/, "&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;") + "</p>"
      end
    end
    
    if !ENV["NODENAME"].blank?
      body_html += "\n\n<p>Server: #{ENV["NODENAME"]}</p>".html_safe
      body_plain += "\n\nServer: #{ENV["NODENAME"]}"
    end
    
    Rails.logger.warn{"handle_exception: " + body_plain}
    
    Myp.send_support_email_safe(subject, body_html.html_safe, body_plain, email: email)
  end
  
  def self.send_support_email_safe(subject, body, body_plain = nil, email: nil)
    begin
      from = Myp.create_email
      if !email.blank?
        from = email
      elsif ExecutionContext.available? && !User.current_user.nil?
        from = User.current_user.email
      end
      
      # Protect email servers from simple DoS
      sleep(1.0)
      
      if ExecutionContext.available? && !User.current_user.nil?
        if !body.blank?
          body += "\n\n<p>User: #{User.current_user.email}</p>".html_safe
        end
        if !body_plain.blank?
          body_plain += "\n\nUser: #{User.current_user.email}"
        end
      end
      
      UserMailer.send_support_email(from, subject, body, body_plain).deliver_now
      
    rescue Exception => e
      puts "Could not send email. Subject: " + subject + ", Body: " + body + ", Email Problem: " + Myp.error_details(e)
    end
  end
  
  def self.send_email(to, subject, body, cc = nil, bcc = nil, body_plain = nil, reply_to = nil, from_prefix: nil)
    begin
      from = Myp.create_email
      UserMailer.send_email(to, subject, body, cc, bcc, body_plain, reply_to, from_prefix: from_prefix).deliver_now
      Rails.logger.info{"send_email to: #{to}, cc: #{cc}, bcc: #{bcc}"}
    rescue Exception => e
      puts "Could not send email. Subject: " + subject + ", Body: " + body + ", Email Problem: " + Myp.error_details(e)
    end
  end
  
  def self.instance_to_category(obj, raise_if_not_found = true)
    if obj.class == IdentityFileFolder
      return Category.new(name: "file_folders")
    elsif obj.class == IdentityFile
      search = "files"
    else
      search = obj.class.name.pluralize.underscore
    end
    Category.all.each do |category|
      if category.name == search
        return category
      end
    end
    if raise_if_not_found
      raise "Could not find category from " + search
    else
      nil
    end
  end
  
  def self.instance_to_category_human_readable(obj)
    Myp.instance_to_category(obj).human_title
  end

  def self.is_probably_i18n(str)
    !str.nil? && str.start_with?("myplaceonline.")
  end
  
  def self.evaluate_if_probably_i18n(str)
    self.is_probably_i18n(str) ? I18n.t(str) : str
  end
  
  def self.process_duration_timespan(duration_str)
    if !duration_str.blank?
      matches = duration_str.match(/(\d+) [^,]+, (\d+):(\d+):(\d+)/)
      matches[1].to_i.days + matches[2].to_i.hours + matches[3].to_i.minutes + matches[4].to_i.seconds
    else
      nil
    end
  end
  
  def self.process_duration_timespan_short(duration_str)
    if !duration_str.blank?
      matches = duration_str.match(/(\d+), (\d+):(\d+):(\d+)/)
      matches[1].to_i.days + matches[2].to_i.hours + matches[3].to_i.minutes + matches[4].to_i.seconds
    else
      nil
    end
  end
  
  def self.heading(name)
    I18n.t("myplaceonline." + name + ".heading_singular")
  end
  
  def self.mktmpdir(&code)
    random_name = SecureRandom.hex(10)
    dirname = File.join(Rails.configuration.tmpdir, random_name)
    Dir.mkdir(dirname)
    begin
      code.call(dirname)
    ensure
      self.rmdir(dirname)
    end
  end
  
  def self.rmdir(dir)
    FileUtils.rm_rf(dir)
  end
  
  def self.tmpfile(prefix, suffix, &code)
    f = Tempfile.new([prefix, suffix], Rails.configuration.tmpdir)
    begin
      code.call(f)
    ensure
      File.delete(f)
    end
  end
  
  def self.is_phonegap_request(params, session)
    params[:phonegap] == "true" || session[:phonegap]
  end
  
  def self.is_initial_phonegap_request(params, session)
    phonegap = params[:phonegap]
    result = !phonegap.nil? && phonegap == "true"
    if result
      session[:phonegap] = true
    end
    result
  end
  
  def self.has_phone?(request)
    true
  end
  
  def self.get_category_list
    search = Myp.categories(User.current_user).merge({
      "foods" => Category.new(name: "foods"),
      "drinks" => Category.new(name: "drinks"),
    })
    
    search.map{|k,v| I18n.t("myplaceonline.category." + v.name) }.sort
  end
  
  def self.get_category_list_select
    search = Myp.categories(User.current_user).merge({
      "foods" => Category.new(name: "foods"),
      "drinks" => Category.new(name: "drinks"),
    })
    
    search.map{|k,v| [I18n.t("myplaceonline.category." + v.name), v.name] }.sort_by { |name, value| name }
  end
  
  def self.category_to_model_name(category_name)
    case category_name
    when "files"
      "IdentityFile"
    when "folders"
      "IdentityFileFolder"
    else
      category_name.camelize.singularize
    end
  end
  
  def self.model_to_category_name(model)
    model.name.underscore.pluralize
  end
  
  def self.count(model, identity)
    model.where(identity: identity).count
  end
  
  def self.model_instances(model, identity, orders: nil)
    model.where(identity: identity).order(orders)
  end
  
  def self.time_delta(target)
    if !target.nil?
      now = User.current_user.time_now
      delta = Myp.time_difference_in_general_human(TimeDifference.between(now, target).in_general)
      if now > target
        I18n.t("myplaceonline.general.delta_time_past", delta: delta)
      else
        I18n.t("myplaceonline.general.delta_time_upcoming", delta: delta)
      end
    else
      nil
    end
  end
  
  def self.requires_invite_code
    !Rails.env.development? && !Rails.env.test?
  end
  
  def self.sanitize_with_null_for_conditions(val)
    if val.nil?
      " IS NULL"
    else
      " = " + ActiveRecord::Base.connection.quote(val)
    end
  end
  
  def self.root_url
    Rails.application.routes.url_helpers.root_url(
      protocol: Rails.configuration.default_url_options[:protocol],
      host: Rails.configuration.default_url_options[:host],
      port: Rails.configuration.default_url_options[:port]
    ).chomp('/')
  end

  def self.param_bool(params, name, default_value: false)
    result = default_value
    v = params[name]
    if !v.blank?
      result = v.to_s.to_bool
    end
    result
  end
  
  def self.param_integer(params, name, default_value: 0)
    result = default_value
    v = params[name]
    if !v.blank?
      result = v.to_i
    end
    result
  end
  
  def self.object_type_human(obj)
    cat = Myp.instance_to_category(obj)
    I18n.t("myplaceonline.category.#{cat.name}").singularize
  end
  
  def self.import_museums
    Location.reset_column_information

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
      m.location.identity = User.current_user.current_identity
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
        phone.identity = User.current_user.current_identity
        phone.number = row["PHONE"]
        m.location.location_phones << phone
      end
      if !row["WEBURL"].blank?
        m.website = Website.new
        m.website.identity = User.current_user.current_identity
        m.website.url = row["WEBURL"].downcase
        m.website.title = m.location.name
      end
      m.identity = User.current_user.current_identity
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
  
  def self.import_zip_codes
    file = Rails.root.join('lib', 'data', 'zip_code_lookup', 'zip_code_lookup.yml')

    zip_codes = YAML.load_file(file)
    
    UsZipCode.delete_all

    zip_codes.each do |zip_code|
      if zip_code.length == 2
        code = zip_code[0]
        json = zip_code[1]
        UsZipCode.create!(
          zip_code: code,
          city: json["city"].titleize,
          state: json["state"],
          latitude: json["latitude"].to_f, 
          longitude: json["longitude"].to_f,
          county: json["county"].titleize,
        )
      else
        raise "Error"
      end
    end
    
    true
  end
  
  def self.original_url(request)
    result = request.original_url
    if Rails.env.production? && result.start_with?("http:")
      result = "https:" + result[5..-1]
    end
    result
  end
  
  DB_LOCK_CALENDAR_ITEM_REMINDERS_ALL = 1
  DB_LOCK_CALENDAR_ITEM_REMINDERS = 2
  DB_LOCK_LOAD_RSS_FEEDS = 3
  
  def self.try_with_database_advisory_lock(key1, key2, &block)
    lock_successful = true
    
    Rails.logger.debug{"try_with_database_advisory_lock enter (#{key1}, #{key2})"}

    if ApplicationRecord.connection.instance_of?(ActiveRecord::ConnectionAdapters::PostgreSQLAdapter)
      
      # pg_try_advisory_xact_lock is safer (in case this process dies before the ensure), but it enforces the block
      # to be in a transaction, which isn't always benign
      
      lock_successful = ApplicationRecord.connection.select_value("select pg_try_advisory_lock(#{key1}, #{key2})")
      Rails.logger.debug{"try_with_database_advisory_lock locked (#{key1}, #{key2}), result: #{lock_successful}"}
    else
      raise "Not implemented"
    end

    if lock_successful
      begin
        block.call
      ensure
        ApplicationRecord.connection.select_value("select pg_advisory_unlock(#{key1}, #{key2})")
      end
    else
      Rails.logger.info{"try_with_database_advisory_lock failed to lock (#{key1}, #{key2})"}
    end
    
    Rails.logger.debug{"try_with_database_advisory_lock unlocked (#{key1}, #{key2}), result: #{lock_successful}"}

    lock_successful
  end

  def self.combine_conditionally(a1, condition, &a2)
    if condition
      a1 + a2.call
    else
      a1
    end
  end
  
  def self.blank_fallback(str, fallback)
    if str.blank?
      fallback
    else
      str
    end
  end
  
  def self.full_text_search(
    user,
    search,
    category: nil,
    parent_category: nil,
    display_category_prefix: true,
    display_category_icon: true,
    filters: {}
  )
    
    Myp.log_response_time(
      name: "Myp.full_text_search"
    ) do
      if search.nil?
        search = ""
      end
      
      original_search = search
      
      search = search.strip.downcase
      
      Rails.logger.debug{"full_text_search: '#{search}'"}
      
      if !search.blank?
        
        Rails.logger.debug{"full_text_search: user: #{user.primary_identity_id}, filters: #{filters.inspect}, category: #{category}, parent_category: #{parent_category}, display_category_prefix: #{display_category_prefix}, display_category_icon: #{display_category_icon}"}
        
        if filters.size > 0
          filters = {
            bool: {
              must: 
                filters.merge!(
                  { identity_id: user.primary_identity_id }
                ).keys.map{|key|
                  { term: { key => filters[key] } }
                }.to_a
            }
          }
        else
          filters = {
            term: {
              identity_id: user.primary_identity_id
            }
          }
        end
        
        # http://stackoverflow.com/questions/37082797/elastic-search-edge-ngram-match-query-on-all-being-ignored
        
        if category.blank?
          query = {
            bool: {
              must: {
                match: {
                  _all: search
                }
              },
              filter: filters
            }
          }
        else
          query = {
            bool: {
              must: [
                {
                  match: {
                    _all: search
                  }
                },
                {
                  match: {
                    _type: category.singularize
                  }
                }
              ],
              filter: filters
            }
          }
        end
        
        # https://www.elastic.co/guide/en/elasticsearch/reference/current/search-request-sort.html
        search_results = UserIndex.query(query).order(visit_count: {order: :desc, missing: :_last}).limit(10).load.objects
        
        results = Myp.process_search_results(
          search_results,
          parent_category,
          original_search,
          display_category_prefix: display_category_prefix,
          display_category_icon: display_category_icon
        )
        
      else
        results = []
      end
      
      Rails.logger.debug{"full_text_search results: #{results.length}"}

      results
    end
  end
  
  def self.process_search_results(search_results, parent_category = nil, original_search = nil, display_category_prefix: true, display_category_icon: true)
    # If category isn't blank and it searched a subitem, then we need
    # to map those back to the original category item
    if !parent_category.blank?
      parent_category_class = Object.const_get(Myp.category_to_model_name(parent_category))
      
      search_results = search_results.map do |search_result|
        if parent_category_class.respond_to?("search_join")
          new_search_result = parent_category_class.joins(parent_category_class.search_join).where(parent_category_class.search_join.to_s.pluralize.to_sym => { parent_category_class.search_join_where => search_result.id } ).first
        else
          new_search_result = parent_category_class.where(search_result.class.table_name.singularize + "_id" => search_result.id).first
        end
        if !new_search_result.nil?
          new_search_result
        else
          nil
        end
      end
      search_results = search_results.compact
    end
    
    results = search_results.map do |search_result|
      result = nil
      prefix_text = ""
      
      Rails.logger.debug{"search_result initial: #{search_result.inspect}"}
      
      original_search_result = search_result
      
      if search_result.respond_to?("final_search_result")
        if !search_result.respond_to?("final_search_result_display?") || search_result.final_search_result_display?
          if display_category_prefix
            prefix_text = I18n.t("myplaceonline.category." + search_result.class.name.pluralize.underscore).singularize
          end
          extra = search_result.display
          if !extra.blank? && display_category_prefix
            prefix_text += " (" + extra + ")"
          end
          if display_category_prefix
            prefix_text += ": "
          end
        end
        search_result = search_result.final_search_result
      end
      
      Rails.logger.debug{"search_result: #{search_result.inspect}"}
      
      if !search_result.nil?
        might_be_archived = search_result.respond_to?("archived")
        if !might_be_archived || (might_be_archived && search_result.archived.nil?)
          category = Myp.instance_to_category(search_result, false)
          if category.nil? && search_result.class != Share
            temp_cat_name = search_result.class.name.pluralize.underscore
            if I18n.exists?("myplaceonline.category." + temp_cat_name)
              category = Category.new(name: temp_cat_name)
            else
              Myp.warn("Myp.process_search_results full_text_search found result but not category (perhaps use final_search_result?): #{search_result.inspect}; search: #{original_search}, user: #{User.current_user.current_identity_id}, category: #{temp_cat_name}, original_search_result: #{original_search_result.inspect}")
            end
          end
          if !category.nil?
            if display_category_prefix
              final_display = prefix_text + category.human_title_singular + ": " + search_result.display
            else
              final_display = prefix_text + search_result.display
            end
            if final_display.length > 100
              final_display = final_display[0..97] + "..."
            end
            split_button_link = nil
            split_button_title = nil
            split_button_icon = nil
            if search_result.respond_to?("action_link")
              split_button_link = search_result.action_link
              if search_result.respond_to?("action_link_title")
                split_button_title = search_result.action_link_title
              end
              if search_result.respond_to?("action_link_icon")
                split_button_icon = search_result.action_link_icon
              end
            end
            final_icon = category.icon
            if search_result.respond_to?("display_icon")
              final_icon = search_result.display_icon
            end
            final_path = "/" + category.name + "/" + search_result.id.to_s
            if search_result.respond_to?("ideal_path")
              final_path = search_result.ideal_path
            end
            result = ListItemRow.new(
              final_display,
              final_path,
              Rails.env.development? && search_result.respond_to?("visit_count") ? search_result.visit_count : nil,
              nil,
              nil,
              original_search,
              display_category_icon ? final_icon : nil,
              split_button_link,
              split_button_title,
              split_button_icon
            )
          end
        end
      end
      
      result
    end
    
    results = results.compact
    
    Rails.logger.debug{"results: #{results.inspect}"}
    
    results
  end
  
  def self.highly_visited(user, limit: 10, min_visit_count: 5)
    Myp.log_response_time(
      name: "Myp.highly_visited"
    ) do
      Rails.logger.debug{"highly_visited"}
      
      search_results = UserIndex.query({
        terms: {
          identity_id: [user.primary_identity_id]
        }
      }).order(visit_count: {order: :desc, missing: :_last}).limit(limit).load.objects
      
      permissions = Permission.where(user_id: user.id)
      if permissions.length > 0
        permissions_results = UserIndex.query({
          terms: {
            "_uid" => permissions.map{|p| p.subject_class.singularize + "#" + p.subject_id.to_s }.to_a
          }
        }).order(visit_count: {order: :desc, missing: :_last}).limit(limit).load.objects
        
        search_results = search_results + permissions_results
        
        search_results.sort! do |sr1, sr2|
          x1 = sr1.respond_to?("visit_count") && !sr1.visit_count.nil? ? sr1.visit_count : 0
          x2 = sr2.respond_to?("visit_count") && !sr2.visit_count.nil? ? sr2.visit_count : 0
          x2 <=> x1
        end
        
        Rails.logger.debug{"highly_visited permissions_results: #{permissions_results.inspect}"}
      end
      
      search_results.delete_if{|x| x.respond_to?("show_highly_visited?") && !x.show_highly_visited? }

      search_results.delete_if{|x| !x.respond_to?("visit_count") || (x.respond_to?("visit_count") && (x.visit_count.nil? || x.visit_count <= min_visit_count)) }
      
      Rails.logger.debug{"highly_visited before processing: #{search_results.inspect}"}

      # This returns a list of list item row objects
      results = Myp.process_search_results(search_results)
      
      Rails.logger.debug{"highly_visited results: #{results.inspect}"}

      Rails.logger.debug{"highly_visited final results: #{results.inspect}"}

      results
    end
  end

  def self.full_text_search?
    !ENV["FTS_TARGET"].blank?
  end
  
  def self.append_query_parameter(url, param_name, param_value)
    if url.index("?").nil?
      url + "?" + param_name + "=" + param_value
    else
      url + "&" + param_name + "=" + param_value
    end
  end
  
  def self.string_to_variable_name(str)
    str.gsub(/[^a-zA-Z]/, "")
  end
  
  def self.is_xml?(str)
    !str.blank? && !str.first(100).index("<?xml").nil?
  end
  
  def self.raw_http_get(url:)
    Rails.logger.info{"Myp.raw_http_get #{url}"}
    RestClient::Request.execute(
      method: :get,
      url: url,
      read_timeout: 15,
      open_timeout: 5,
      max_redirects: 5,
      headers: {
        "User-Agent" => "myplaceonline.com V1.0 (https://myplaceonline.com/)"
      }
    )
  end
  
  # Returns:
  #  {
  #    body: string; HTTP body
  #    raw_response: object; underlying response from client library
  #  }
  def self.http_get(url:, try_https: false)
    Myp.log_response_time(
      name: "Myp.http_get",
      url: url
    ) do
      # If there is no TLD and it's not localhost, assume .com
      if url.index(".").nil? && url.index("localhost").nil?
        url += ".com/"
      end
      
      # If no protocol, assume HTTP(S)
      if url.index("://").nil?
        if try_https
          addedhttps = true
          url = "https://" + url
        else
          url = "http://" + url
        end
      end
      
      # If it's only HTTP, and try_https is true, then try switching to HTTPS
      if try_https && url.downcase.start_with?("http") && !url.downcase.start_with?("https")
        addedhttps = true
        url = "https://" + url[7..-1]
      end

      begin
        response = Myp.raw_http_get(url: url)
      rescue => e
        if addedhttps
          Rails.logger.info{"Re-trying vanilla HTTP due to #{e.to_s}"}
          url = "http" + url[5..-1]
          response = Myp.raw_http_get(url: url)
        else
          raise e
        end
      end
      
      final_url = url
      if response.history.length > 0
        final_url = response.history.last.request.url
      end
      
      if url == final_url
        context = url
      else
        context = url + " -> " + final_url
      end
      
      {
        body: response.body,
        raw_response: response,
        final_url: url
      }
    end
  end
  
  def self.valid_link?(link)
    result = false
    if !link.blank?
      begin
        link_uri = URI.parse(URI.escape(link))
        if !link_uri.scheme.nil?
          if Rails.env.production?
            # Don't allow IP addresses for now - need to blacklist myplaceonline IPs
            if link_uri.scheme.start_with?("http") && (link_uri.host =~ /^[\d\.:]+$/).nil? && !link_uri.host.include?("localhost") && !link_uri.host.include?(".myplaceonline.com")
              result = true
            end
          else
            if link_uri.scheme.start_with?("http")
              result = true
            end
          end
        end
      rescue URI::InvalidURIError
        # Do nothing, just return false (but warn so we can see any patterns)
        Myp.warn("valid_link InvalidURIError for #{link}")
      end
    end
    if !result
      Myp.warn("valid_link invalid link: #{link}")
    end
    result
  end
  
  def self.website_info(link)
    if Myp.valid_link?(link)
      response = Myp.http_get(url: link, try_https: true)
      
      # If it's XML, we assume it's RSS
      if Myp.is_xml?(response[:body])
        f = Feed.load_feed_from_string(response[:body])
        title = f.channel.title
      else
        title = response[:body][/.*<(title|TITLE)>([^>]*)<\/(title|TITLE)>/,2]
      end
      
      title = title.gsub("\n", " ")
      
      {
        title: title,
        link: response[:final_url]
      }
    else
      nil
    end
  end
  
  @@twilio_client = nil
  @@twilio_number = nil
  
  def self.initialize_sms
    if !ENV["TWILIO_NUMBER"].blank?
      @@twilio_number = ENV["TWILIO_NUMBER"]
      Rails.logger.info{"Twilio credentials available, initializing with #{@@twilio_number}"}
      @@twilio_client = Twilio::REST::Client.new(ENV["TWILIO_ACCOUNT"], ENV["TWILIO_AUTH"])
    else
      if Rails.env.production?
        Rails.logger.warn{"Twilio not configured"}
      end
    end
  end
  
  # https://github.com/twilio/twilio-ruby
  def self.send_sms(to: nil, body: nil, from: @@twilio_number)
    if !@@twilio_client.nil?
      Rails.logger.info{"Sending twilio SMS to: #{to}, body: #{body}"}
      
      if TextMessageUnsubscription.where(
        "phone_number = ? and category is null and identity_id is null",
        TextMessage.normalize(phone_number: to)
      ).first.nil?
        @@twilio_client.messages.create(
          from: from,
          to: to,
          body: body
        )
      else
        Rails.logger.debug{"Not sending SMS because unsubscribed: #{to}, body: #{body}"}
      end
    else
      Rails.logger.info{"Not sending SMS because Twilio unconfigured: #{to}, body: #{body}"}
    end
  end

  Myp.initialize_sms
  
  def self.process_param_braces(params)
    result = params.dup
    result.dup.each do |key, value|
      if !key.match(/%5[bBdD]/).nil?
        Myp.process_param_braces_recurse(result, key, value)
      end
    end
    result
  end
  
  def self.process_param_braces_recurse(hash, key, value)
    pieces = key.split(/%5[bBdD]/)
    target = hash
    last = nil
    pieces.first(pieces.length - 1).each do |piece|
      last = piece
      next_hash = target[piece]
      if next_hash.nil?
        target[piece] = Hash.new
        next_hash = target[piece]
      end
      target = next_hash
    end
    last_piece = pieces[pieces.length - 1]
    target[last_piece] = value
    hash.delete(key)
  end
  
  class SuddenRedirectError < StandardError
    def initialize(path, notice = nil)
      @path = path
      @notice = notice
    end
    
    def path
      @path
    end

    def notice
      @notice
    end
  end
  
  def self.ellipses_if_needed(str, maxlength)
    if !str.blank? && str.length > (maxlength - 3)
      str[0..maxlength - 1] + "..."
    else
      str
    end
  end

  def self.models_count(check_database: true)
    count = 0
    Dir.new(Rails.root.join("app", "models").to_s).each do |model_path|
      if model_path.end_with?(".rb")
        count += 1
      end
    end
    count
  end

  def self.process_models(check_database: true, &block)
    Rails.application.eager_load!
    ApplicationRecord.descendants.each do |klass|
      next unless klass.ancestors.include?(ApplicationRecord)
      if klass.include?(MyplaceonlineActiveRecordIdentityConcern) && (!check_database || ApplicationRecord.connection.data_source_exists?(klass.table_name))
        block.call(klass)
      end
    end
  end
  
  def self.process_model_names(&block)
    Dir.new(Rails.root.join("app", "models").to_s).each do |model_path|
      if model_path.end_with?(".rb")
        block.call(model_path[0..model_path.length-4])
      end
    end
  end
  
  def self.date_max(x, y)
    x > y ? x : y
  end
  
  def self.log_response_time(name:, **options, &block)
    start_time = Time.now
    begin
      block.call
    ensure
      end_time = Time.now
      diff = (end_time - start_time) * 1000.0
      
      if !options.nil? && options.length > 0
        Rails.logger.info{"#{name} response time in milliseconds = #{sprintf("%0.02f", diff)} context: #{options}"}
      else
        Rails.logger.info{"#{name} response time in milliseconds = #{sprintf("%0.02f", diff)}"}
      end
    end
  end
  
  def self.within_a_day?(time:, user: User.current_user)
    diff = time - user.time_now
    diff > 0 && diff <= 1.days
  end
  
  def self.debug_print(obj, depth: 0)
    
    if obj.is_a?(ActionController::Parameters)
      obj = obj.dup.permit!.to_hash
    end
    
    padding_self = depth == 0 ? "" : "\t".ljust(depth, "\t")
    padding_children = "\t".ljust(depth + 1, "\t")
    
    # use awesome print
    result = padding_self + obj.ai

    if !obj.nil?
      MyplaceonlineActiveRecordBaseConcern.get_attributes_model_mappings(klass: obj.class).each do |name, model|
        child = obj.send(name)
        if !child.nil?
          result += "\n#{padding_children}Child property: #{name}\n#{padding_children}" + Myp.debug_print(child, depth: depth + 1)
        end
      end
    end
    
    result
  end
  
#   def self.play
#     ["aes-256-cbc", "aes-128-gcm"].each do |cipher|
#       puts "Cipher: #{cipher}"
#       salt  = SecureRandom.random_bytes(64)
#       key   = ActiveSupport::KeyGenerator.new('password').generate_key(salt, 32)
#       crypt = ActiveSupport::MessageEncryptor.new(key, cipher: cipher)
#       encrypted_data = crypt.encrypt_and_sign('my secret data')
#       puts crypt.decrypt_and_verify(encrypted_data)
#     end
#   end
   
  def self.create_default_website
    website = Website.create!(
      identity_id: User::SUPER_USER_IDENTITY_ID,
      title: "Myplaceonline.com",
    )
    WebsiteDomain.create!(
      identity_id: User::SUPER_USER_IDENTITY_ID,
      domain_name: "myplaceonline",
      verified: true,
      default_domain: true,
      meta_description: I18n.t("myplaceonline.default_domain.meta_description"),
      meta_keywords: I18n.t("myplaceonline.default_domain.meta_keywords"),
      hosts: "myplaceonline.com",
      static_homepage: Myp.parse_yaml_to_html("myplaceonline.default_domain.homepage"),
      menu_links_static: "",
      menu_links_logged_in: "",
      website: website,
      new_user_welcome: I18n.t("myplaceonline.default_domain.new_user_welcome"),
      about: Myp.parse_yaml_to_html("myplaceonline.default_domain.about"),
      mission_statement: Myp.parse_yaml_to_html("myplaceonline.default_domain.mission_statement"),
      faq: Myp.parse_yaml_to_html("myplaceonline.default_domain.faq"),
    )
  end
  
  def self.media_wiki_str_to_markdown(str, link_prefix: "/", image_prefix: "/")
    
    original_str = str
    
    link_references = {}
    link_references_names = {}
    
    str = str.gsub("== References ==", "")
    
    i = 0
    while true do
      match_data = str.match(/<ref>([^\[]*)\[([^ ]+) ([^\]]+)\]([^<]*)<\/ref>/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        link_reference_id = (link_references.count + 1).to_s
        link_references[link_reference_id] = {
          link: match_data[2],
          text: match_data[1] + match_data[3] + match_data[4],
        }
        replacement = " <sup>[" + link_reference_id + "][" + link_reference_id + "]</sup>"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/<ref>([^\[]*)\[([^\]]+)\]([^<]*)<\/ref>/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        link_reference_id = (link_references.count + 1).to_s
        link_references[link_reference_id] = {
          link: match_data[2],
          text: match_data[1] + match_data[3],
        }
        replacement = " <sup>[" + link_reference_id + "][" + link_reference_id + "]</sup>"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/<ref name="([^"]+)">([^\[]+)\[([^ ]+) ([^\]]+)\]([^<]*)<\/ref>/, i)
      if !match_data.nil?
        if str[match_data.offset(1)[1]+2] != '<'
          match_offset = match_data.offset(0)[0]
          link_reference_id = (link_references.count + 1).to_s
          link_references_names[match_data[1]] = link_reference_id
          link_references[link_reference_id] = {
            link: match_data[3],
            text: match_data[2] + match_data[4] + match_data[5],
          }
          replacement = " <sup>[" + link_reference_id + "][" + link_reference_id + "]</sup>"
          str = match_data.pre_match + replacement + match_data.post_match
          i = match_offset + replacement.length
        else
          i = match_data.offset(1)[1]+2
        end
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/<ref name="([^"]+)" ?\/>/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        link_reference_id = link_references_names[match_data[1]]
        if link_reference_id.nil?
          raise "Could not find matching reference for #{match_data[1]}. Names: #{link_references_names}, Input: #{original_str}, Modified: #{str}"
        end
        replacement = " <sup>[" + link_reference_id + "][" + link_reference_id + "]</sup>"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/<ref name="([^"]+)"><\/ref>/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        link_reference_id = link_references_names[match_data[1]]
        if link_reference_id.nil?
          raise "Could not find matching reference for #{match_data[1]}. Names: #{link_references_names}, Input: #{original_str}, Modified: #{str}"
        end
        replacement = " <sup>[" + link_reference_id + "][" + link_reference_id + "]</sup>"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end

    # External link
    i = 0
    while true do
      match_data = str.match(/\[([a-z]+:[^\[\]]+?) ([^\]]+)\]/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        if match_offset == 0 || str[match_offset-1] != '['
          replacement = "[" + match_data[2] + "](" + match_data[1] + ")"
          str = match_data.pre_match + replacement + match_data.post_match
        else
          replacement = "[" + match_data[2] + " " + match_data[1] + "]"
        end
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/\[(\/\/[^\[\]]+?) ([^\]]+)\]/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        if match_offset == 0 || str[match_offset-1] != '['
          replacement = "[" + match_data[2] + "](" + match_data[1] + ")"
          str = match_data.pre_match + replacement + match_data.post_match
        else
          replacement = "[" + match_data[2] + " " + match_data[1] + "]"
        end
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/'''/, i)
      if !match_data.nil?
        start = match_data.offset(0)[0]
        endi = str.index("'''", start + 3)
        replacement = "**" + str[start+3..endi-1] + "**"
        str = match_data.pre_match + replacement + str[endi+3..-1]
        i = start + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/== ([^=]+)==\n/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = "# <a name=\"" + match_data[1].strip + "\"></a>" + match_data[1] + "\n"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/=== ([^=]+)===\n/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = "## <a name=\"" + match_data[1].strip + "\"></a>" + match_data[1] + "\n"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/==== ([^=]+)====\n/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = "### <a name=\"" + match_data[1].strip + "\"></a>" + match_data[1] + "\n"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/===== ([^=]+)=====\n/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = "#### <a name=\"" + match_data[1].strip + "\"></a>" + match_data[1] + "\n"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/\[\[File:([^\]]+)\]\]/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = "<p><img src=\"" + image_prefix + match_data[1] + "\" /></p>"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/\[\[([^\]]+)\]\]/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        post = match_data[1]
        fragment = nil
        explicit_title = false

        j = post.rindex("|")
        if !j.nil?
          title = post[j+1..-1]
          post = post[0..j-1]
          explicit_title = true
        else
          title = post
        end

        j = post.rindex("#")
        if !j.nil?
          fragment = post[j+1..-1]
          post = post[0..j-1]
          if !explicit_title
            title = post
          end
        end

        replacement = "[" + title + "]("
        replacement << link_prefix + post
        if !fragment.nil?
          replacement << "#" + fragment
        end
        replacement << ")"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/<blockquote>(.+?)<\/blockquote>/m, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = "> " + match_data[1].gsub("\n", "\n> ")
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    all_references = link_references.map{|k,v|
      "  [" + k + "]: " + v[:link] + " (" + v[:text].gsub("(", "").gsub(")", "").gsub("\n", "") + ")"
    }.join("\n")

    if str.index("<references/>").nil?
      str << "\n" + all_references
    else
      str = str.gsub("<references/>", all_references)
    end
    
    str = str.gsub("__NOTOC__", "")

    str
  end
  
  # If id_hash is true, then asume the first value inserted is the row's ID, and create a result of the form:
  #   {
  #     "1" => [column2, column3, [...], columnN],
  #     [...]
  #     "N" => [column2, column3, [...], columnN]
  #   }
  # Otherwise, create a result of the form:
  #   [
  #     ["1", column2, column3, [...], columnN],
  #     [...]
  #     ["N", column2, column3, [...], columnN]
  #   ]
  def self.parse_sql_insert(sql, id_hash: false)
    if id_hash
      result = {}
    else
      result = []
    end
    sql = sql[sql.index("VALUES ")+7..-1]
    state = 0
    str = ""
    item = nil
    escaping = false
    sql.each_char do |char|
      case state
      when 0
        if char == '('
          state = 1
          item = []
        elsif char == ','
          # no-op
        else
          raise "Expecting ( or , but found #{char}"
        end
      when 1
        if char == ')'
          item.push(str)
          if id_hash
            result[item[0]] = item[1..-1]
          else
            result.push(item)
          end
          str = ""
          state = 0
        elsif char == '\''
          escaping = false
          state = 2
        elsif char == ','
          item.push(str)
          str = ""
        else
          str << char
        end
      when 2
        if escaping
          escaping = false
          if char == 'n'
            str << "\n"
          elsif char == 'r'
            str << "\r"
          elsif char == 't'
            str << "\t"
          else
            str << char
          end
        else
          if char == '\\'
            escaping = true
          else
            if char == '\''
              state = 1
            else
              str << char
            end
          end
        end
      else
        raise "TODO"
      end
    end
    result
  end
  
  def self.play(file)
    statements = File.read(file).split(/;$/)
    
    posts = {}
    
    statements.each do |statement|
      statement.lstrip!
      if statement.start_with?("INSERT INTO `wp_posts`")
        rows = Myp.parse_sql_insert(statement)
        rows.each do |row|
          if row[7] == "publish" && row[20] == "post"
            posts[row[0]] = row
          end
        end
      end
    end
    
    posts.each do |post_id, post|
      date_local = Date.strptime(post[14], "%Y-%m-%d %H:%M:%S")
      
      content = post[4]
      # https://github.com/xijo/reverse_markdown
      #content_markdown = ReverseMarkdown.convert(content, unknown_tags: :pass_through, github_flavored: true)
      content_markdown = Myp.html_to_markdown(content)
      title = post[5]
      puts "#{title}:\n#{content_markdown}"
    end
    
    nil
  end
  
#   def self.play(*args)
#     args_array = *args
#     args_array = [{ context: 1 }] + args_array 
#     self.play2(*args_array)
#   end
#   
#   def self.play2(*args)
#     job_context = args.shift
#     puts "play2: context: #{job_context}; #{args}"
#   end
  
  def self.is_number?(str)
    !!(str =~ /\A[-+]?[0-9]+\z/)
  end
  
  # http://stackoverflow.com/a/7085969
  def self.renderActionInOtherController(controller, action, params)
    c = controller.new
    c.params = params
    # TODO before_actions are not called (process_action is protected and
    # calling it through a public wrapper doesn't work)
    r = controller.make_response!(MyplaceonlineExecutionContext.request)
    c.dispatch(action, MyplaceonlineExecutionContext.request, r)
    if r.response_code == 302
      # Assume password required redirect
      raise Myp::DecryptionKeyUnavailableError
    end
    r.body
  end
  
  def self.html_to_markdown(str, image_prefix: "/", thumbnails_prefix: "/")
    
    original_str = str
    
    i = 0
    while true do
      match_data = str.match(/<blockquote>(.+?)<\/blockquote>/m, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = "> " + match_data[1].gsub("\n", "\n> ") + "\n"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/<a.*?href="([^"]+)"[^>]*><img.*?src="([^"]+)"[^>]+><\/a>/, i)
      if !match_data.nil?
        if !match_data[1].index("wp-content/uploads").nil?
          match_offset = match_data.offset(0)[0]
          file = match_data[1]
          file = file[file.rindex("/")+1..-1]
          replacement = "<a href=\"" + image_prefix + file + "\" rel=\"external\"><img src=\"" + thumbnails_prefix + file + "\" /></a>"
          str = match_data.pre_match + replacement + match_data.post_match
          i = match_offset + replacement.length
        else
          i = match_data.offset(0)[1]
        end
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/\[audio mp3="([^"]+)"\]\[\/audio\]/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        file = match_data[1]
        file = file[file.rindex("/")+1..-1]
        replacement = "<audio src=\"" + image_prefix + file + "\" preload=\"none\" controls></audio>"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/\[video.*?flv="([^"]+)"[^\]]*\]\[\/video\]/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        file = match_data[1]
        file = file[file.rindex("/")+1..-1]
        replacement = "<video src=\"" + image_prefix + file + "\" preload=\"none\" controls></video>"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/<a href="([^"]+)"[^>]*>([^<]+)<\/a>/, i)
      if !match_data.nil?
        if match_data[0].index("rel=\"external\"").nil?
          match_offset = match_data.offset(0)[0]
          replacement = "[" + match_data[2] + "](" + match_data[1] + ")"
          str = match_data.pre_match + replacement + match_data.post_match
          i = match_offset + replacement.length
        else
          i = match_data.offset(0)[1]
        end
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/[ \t]*<li>([^<]+)<\/li>/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = "* " + match_data[1].strip
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/<div[^>]+>([^<]+)<\/div>/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = match_data[1].strip
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/<span[^>]+>([^<]+)<\/span>/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = match_data[1].strip
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    i = 0
    while true do
      match_data = str.match(/<p[^>]*>([^<]+)<\/p>/, i)
      if !match_data.nil?
        match_offset = match_data.offset(0)[0]
        replacement = "\n" + match_data[1] + "\n"
        str = match_data.pre_match + replacement + match_data.post_match
        i = match_offset + replacement.length
      else
        break
      end
    end
    
    str = str.gsub("<ul>", "").gsub("</ul>", "").gsub("<ol>", "").gsub("</ol>", "")
    
    str
  end
  
  def self.spawn(command_line:, process_error: true, current_directory: nil)
    # https://github.com/rtomayko/posix-spawn
    child = POSIX::Spawn::Child.new(command_line, chdir: current_directory)
    # child.out, child.err, child.status (Process::Status)
    if process_error && child.status.exitstatus != 0
      raise "Error #{child.status.exitstatus} spawning #{command_line}, stdout: #{child.out}, stderr: #{child.err}"
    end
    child
  end
  
  Rails.logger.info{"myplaceonline: myp.rb static initialization ended"}
end
