# [Card::Link] model serializer
class Card::LinkSerializer < CardSerializer
  root :link
  attributes :url, :content
end
