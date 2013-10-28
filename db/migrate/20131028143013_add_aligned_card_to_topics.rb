class AddAlignedCardToTopics < ActiveRecord::Migration
  def change
    add_reference :topics, :aligned_card, index: true

    remove_column :cards, :alignment
  end
end
