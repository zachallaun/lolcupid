json.array! Champion.order(name: :asc) do |champion|
  json.extract! champion, :id, :name, :key, :display_title, :image_url
end
