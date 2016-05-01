class Champion < ActiveRecord::Base
  def self.from_api(asset_version, api_data)
    where(champion_id: api_data[:id]).first_or_initialize do |champion|
      champion.asset_version = asset_version
      champion.name = api_data[:name]
      champion.key = api_data[:key]
      champion.title = api_data[:title]
      champion.image = api_data[:image][:full]
    end
  end

  def image_url
    RiotClient::ASSET_PREFIX + "#{asset_version}/img/champion/#{image}"
  end
end
