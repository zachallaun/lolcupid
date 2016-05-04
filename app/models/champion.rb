class Champion < ActiveRecord::Base
  has_many :champion_masteries
  has_many :recommendations, -> { order(score: :desc) }, foreign_key: 'champion_in_id', class_name: 'ChampionRecommendation'

  def self.from_api(asset_version, api_data)
    champion = where(id: api_data[:id]).first_or_initialize

    name = api_data[:name]

    champion.asset_version = asset_version
    champion.name  = name
    champion.key   = api_data[:key]
    champion.title = api_data[:title]
    champion.image = api_data[:image][:full]
    champion.skins = api_data[:skins]

    champion.release_date = ChampionConstants::CHAMP_RELEASE_DATES[name]
    champion.nickname     = ChampionConstants::CHAMP_NICKNAMES[name]

    ChampionConstants.roles_for(name).each do |role|
      champion.send("#{role}=", true)
    end

    champion
  end

  def self.random_splash
    random_champ = Champion.order("RANDOM()").first
    random_skin_num = random_champ.skins.sample["num"]
    splash_name = "#{random_champ.key}_#{random_skin_num}"
    RiotClient::ASSET_PREFIX + "img/champion/splash/#{splash_name}.jpg"
  end

  # def self.get_id(name)
  #   return Champion.where(name: name).first.id
  # end

  def self.standardize_name(name)
    name = name.downcase
    ret = []
    for part in name.split(" ")
      ret.push(part.split("'").map(&:capitalize).join("'"))
    end
    return ret.join(" ")
  end

  def self.standardize_name_url(name)
    name = name.gsub('_', ' ')
    return standardize_name(name)
  end

  def image_url
    RiotClient::ASSET_PREFIX + "#{asset_version}/img/champion/#{image}"
  end

  def display_title
    nickname || title
  end
end
