# [Card::Link] model serializer
class Card::LinkSerializer < CardSerializer
  attributes :url, :content, :_link

  # Dummy attribute to make happy ember data
  def _link
  end
end
