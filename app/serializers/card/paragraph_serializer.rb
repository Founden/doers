# [Card::Paragraph] model serializer
class Card::ParagraphSerializer < CardSerializer
  attributes :_paragraph

  # Dummy attribute to make happy ember data
  def _paragraph
  end
end
