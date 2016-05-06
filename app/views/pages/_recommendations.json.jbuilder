json.query_champions query_champions do |champ|
  json.extract! champ, :id, :name, :display_title, :image_url
end

json.recommendations recommendations do |champ|
  json.extract! champ, :id, :name, :display_title, :image_url, :splash_url, :score, :can_top, :can_jungle, :can_mid, :can_bot_carry, :can_bot_support
end
