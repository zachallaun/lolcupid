json.champions Champion.all do |champion|
  json.extract! champion, :id, :champion_id, :name, :key, :title, :image_url
end
