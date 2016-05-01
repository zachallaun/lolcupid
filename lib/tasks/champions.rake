namespace :champions do
  desc "Update database with current champion static data"
  task pull: :environment do
    client = RiotClient.new

    champion_static_data = client.static.champion.all("na", champData: "image")

    champion_static_data[:data].each do |_, champ|
      Champion.from_api(champion_static_data[:version], champ).save!
    end
  end
end