class TransformBookQuotes < ActiveRecord::Migration[5.0]
  def change
    BookQuote.all.each do |book_quote|
      MyplaceonlineExecutionContext.do_context(book_quote) do
        quote = Quote.create(
          quote_text: book_quote.book_quote,
          identity_id: book_quote.identity_id
        )
        book_quote.quote = quote
        book_quote.save!
      end
    end
  end
end
