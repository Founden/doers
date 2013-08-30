Fabricator(:team) do
  title       { sequence(:team_title){ Faker::Company.name } }
  description Faker::Company.catch_phrase
  website     Faker::Internet.http_url
  after_create do |team, trans|
    team.banner = Fabricate(:banner, :assetable => team)
    2.times { Fabricate(:board, :team => team) }
  end
end
