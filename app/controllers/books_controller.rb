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
  
  def may_upload
    true
  end

  protected
    def insecure
      true
    end

    def sorts
      ["lower(books.book_name) ASC"]
    end

    def obj_params
      params.require(:book).permit(
        :book_name,
        :isbn,
        :author,
        :is_read,
        :notes,
        :review,
        :lent_date,
        :borrowed_date,
        recommender_attributes: ContactsController.param_names,
        lent_to_attributes: ContactsController.param_names,
        borrowed_from_attributes: ContactsController.param_names,
        book_files_attributes: FilesController.multi_param_names,
        book_quotes_attributes: [
          :id,
          :_destroy,
          :book_quote,
          :pages
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
