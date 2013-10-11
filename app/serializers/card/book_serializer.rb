# [Card::Book] model serializer
class Card::BookSerializer < CardSerializer
  root :book
  attributes :url, :book_title, :book_authors

  has_one :image, :embed => :id
end
