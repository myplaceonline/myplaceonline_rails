class BooksController < MyplaceonlineController
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
        recommender_attributes: ContactsController.param_names
      )
    end
end
