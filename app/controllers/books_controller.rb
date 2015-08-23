class BooksController < MyplaceonlineController
  def model
    Book
  end

  protected
    def sorts
      ["lower(books.book_name) ASC"]
    end

    def obj_params
      params.require(:book).permit(
        :book_name,
        :isbn,
        :author,
        :is_read,
        :notes
      )
    end
end
