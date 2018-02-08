class BooksController < MyplaceonlineController
  def index
    @read = param_bool(:read)
    @lent = param_bool(:lent)
    @borrowed = param_bool(:borrowed)
    super
  end

  def footer_items_index
    super + [
      {
        title: @read.nil? ? I18n.t("myplaceonline.books.unread_books") : I18n.t("myplaceonline.books.all_books_back"),
        link: @read.nil? ? books_path(read: "false") : books_path,
        icon: "bars"
      },
      {
        title: @lent.nil? ? I18n.t("myplaceonline.books.lent_books") : I18n.t("myplaceonline.books.all_books_back"),
        link: @lent.nil? ? books_path(lent: "true") : books_path,
        icon: "bars"
      },
      {
        title: @borrowed.nil? ? I18n.t("myplaceonline.books.borrowed_books") : I18n.t("myplaceonline.books.all_books_back"),
        link: @borrowed.nil? ? books_path(borrowed: "true") : books_path,
        icon: "bars"
      }
    ]
  end
  
  def footer_items_show
    result = super
    
    if !MyplaceonlineExecutionContext.offline?
      result << {
        title: I18n.t("myplaceonline.books.discard"),
        link: book_discard_path(@obj),
        icon: "navigation"
      }
    end
    
    result
  end
  
  def may_upload
    true
  end
  
  def discard
    set_obj
    @obj.is_discarded = true
    @obj.save!
    redirect_to index_path,
      :flash => { :notice =>
                  I18n.t("myplaceonline.books.discarded")
                }
  end

  protected
    def insecure
      true
    end

    def additional_sorts
      [
        [I18n.t("myplaceonline.books.book_name"), default_sort_columns[0]]
      ]
    end

    def default_sort_columns
      ["lower(books.book_name)"]
    end

    def obj_params
      params.require(:book).permit(
        :book_name,
        :isbn,
        :author,
        :is_read,
        :is_owned,
        :is_discarded,
        :notes,
        :review,
        :lent_date,
        :borrowed_date,
        :book_category,
        :acquired,
        :book_location,
        recommender_attributes: ContactsController.param_names,
        lent_to_attributes: ContactsController.param_names,
        borrowed_from_attributes: ContactsController.param_names,
        book_files_attributes: FilesController.multi_param_names,
        gift_from_attributes: ContactsController.param_names,
        book_quotes_attributes: [
          :id,
          :_destroy,
          :pages,
          quote_attributes: Quote.params
        ]
      )
    end

    def all_additional_sql(strict)
      if strict
        nil
      else
        result = nil
        if !@read.nil? && !@read
          result = Myp.appendstr(result, "when_read is null", nil, " and ")
        end
        if !@lent.nil? && @lent
          result = Myp.appendstr(result, "lent_to_id is not null", nil, " and ")
        end
        if !@borrowed.nil? && @borrowed
          result = Myp.appendstr(result, "borrowed_from_id is not null", nil, " and ")
        end
        result
      end
    end
end
