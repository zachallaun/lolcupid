json.query_champions query_champions do |champ|
  json.extract! champ, :id, :name, :display_title, :image_url
end

json.recommendations recommendations do |champ|
  json.extract! champ, :id, :name, :display_title, :image_url, :score
end

json.champions { json.partial! 'champions.json' }
