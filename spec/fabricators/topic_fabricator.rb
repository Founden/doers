Fabricator(:topic) do
  title       { Faker::Lorem.sentence }
  description { Faker::Lorem.phrases(4).join("\n") }
  user
  project     { |attrs| Fabricate(:project, :user => attrs[:user]) }
  board       { |attrs| Fabricate(
    :board, :user => attrs[:user], :project => attrs[:project]) }
end

Fabricator(:topic_with_card, :from => :topic) do
  after_create do |topic, trans|
    card = Fabricate('card/paragraph',
      :project => topic.project, :board => topic.board, :topic => topic)
    topic.update_attribute(:aligned_card, card)
  end
end

Fabricator(:topic_with_cards, :from => :topic) do
  after_create do |topic, trans|
    Fabricate('card/paragraph',
      :user => topic.user, :project => topic.project, :board => topic.board, :topic => topic)
    Fabricate('card/paragraph',
      :project => topic.project, :board => topic.board, :topic => topic)
  end
end

Fabricator(:whiteboard_topic, :from => :topic) do
  user
  whiteboard  { |attrs| Fabricate(:whiteboard, :user => attrs[:user]) }
  board       {}
end
