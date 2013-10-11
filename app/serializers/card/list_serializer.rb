# [Card::List] model serializer
class Card::ListSerializer < CardSerializer
  root :list
  attributes :content, :items
end
