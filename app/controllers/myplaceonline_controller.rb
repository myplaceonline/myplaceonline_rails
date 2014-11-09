class MyplaceonlineController < ApplicationController
  
  # Return a list of CategoryForIdentity objects.
  # Assumes user is logged in.
  #
  # If parent is nil, search for all categories.
  # If parent is -1, search for all root categories.
  # Parent is is >= 0, search for all categories with a particular parent.
  def categoriesForCurrentUser(parent = nil, orderByName = false)
    # We want a set of categories, left outer joined with points for each of
    # those for the current user, if available.
    #
    # Ideally we would use something like:
    #
    # Category.where(parent: nil).order(:position)
    #   .includes(:category_points_amounts)
    #   .where(category_points_amounts:
    #     {identity: current_user.primary_identity}
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

    Category.find_by_sql(%{
      SELECT categories.*, category_points_amounts.count as points_amount
      FROM categories
      LEFT OUTER JOIN category_points_amounts
        ON category_points_amounts.category_id = categories.id
            AND category_points_amounts.identity_id = #{
                CategoryPointsAmount.sanitize(current_user.primary_identity.id)
              }
      #{ parent.nil? ?
           "" :
           %{
              WHERE categories.parent_id #{
                parent == -1 ?
                  "IS NULL" :
                  "= " + parent.id.to_s
              }
            }
       }
      ORDER BY #{
        orderByName ?
          "categories.name ASC" :
          "categories.position ASC"
      }
    }).map{ |category|
      CategoryForIdentity.new(
        t("myplaceonline.category." + category.name.downcase),
        category.link,
        category.points_amount.nil? ? 0 : category.points_amount
      )
    }
  end

  class CategoryForIdentity
    def initialize(title, link, count)
      @title = title
      @link = link
      @count = count
    end
  end
end
