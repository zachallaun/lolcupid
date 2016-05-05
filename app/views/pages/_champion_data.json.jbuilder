json.recommended_champions @recommended_champs do |c|
  json.extract! c, :id, :name, :score, :image_url, :can_top, :can_jungle, :can_mid, :can_bot_carry, :can_bot_support
end

json.champions do
  json.partial! 'champions.json'
end
