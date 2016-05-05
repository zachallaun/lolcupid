json.array! Champion.all do |champion|
  json.extract! champion, :id, :name, :key, :display_title, :image_url
end
