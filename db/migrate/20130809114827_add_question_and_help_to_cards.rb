class AddQuestionAndHelpToCards < ActiveRecord::Migration
  def change
    add_column :cards, :question, :string
    add_column :cards, :help, :text
  end
end
