Fabricator(:team) do
  transient   :boards_count => 2
  title       { sequence(:team_title){ Faker::Company.name } }
  description Faker::Company.catch_phrase
  website     Faker::Internet.http_url
  angel_list  'http://angel.co/%s' % Faker::Lorem.word
  after_create do |team, trans|
    team.banner = Fabricate(:banner, :assetable => team)
    trans[:boards_count].times { Fabricate(:board, :team => team) }
  end
end
