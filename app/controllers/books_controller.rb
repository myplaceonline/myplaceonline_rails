class BooksController < MyplaceonlineController
  def index
    @read = params[:read]
    if !@read.blank?
      @read = @read.to_bool
    end
    super
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
        recommender_attributes: ContactsController.param_names,
        book_quotes_attributes: [
          :id,
          :_destroy,
          :book_quote,
          :pages
        ]
      )
    end

    def all_additional_sql(strict)
      if (!@read.nil? && !@read) && !strict
        "and when_read is null"
      else
        nil
      end
    end
end
