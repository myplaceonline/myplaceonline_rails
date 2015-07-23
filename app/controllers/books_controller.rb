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

    def create_presave
      update_read
    end
    
    def update_presave
      update_read
    end
    
    def update_read
      if @obj.is_read == "1"
        @obj.when_read = Time.now
      else
        @obj.when_read = nil
      end
    end

    def before_edit
      @obj.is_read = !@obj.when_read.nil?
    end
end
