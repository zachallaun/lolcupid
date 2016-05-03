class Champion < ActiveRecord::Base
  has_many :champion_masteries

  def self.from_api(asset_version, api_data)
    champion = where(id: api_data[:id]).first_or_initialize

    name = api_data[:name]

    champion.asset_version = asset_version
    champion.name  = name
    champion.key   = api_data[:key]
    champion.title = api_data[:title]
    champion.image = api_data[:image][:full]

    champion.release_date = ChampionConstants::CHAMP_RELEASE_DATES[name]
    champion.nickname     = ChampionConstants::CHAMP_NICKNAMES[name]

    ChampionConstants.roles_for(name).each do |role|
      champion.send("#{role}=", true)
    end

    champion
  end

  def image_url
    RiotClient::ASSET_PREFIX + "#{asset_version}/img/champion/#{image}"
  end

  def display_title
    nickname || title
  end
end
