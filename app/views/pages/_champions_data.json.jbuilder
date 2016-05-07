json.partial! 'recommendations.json', query_champions: query_champions, recommendations: recommendations

json.champions { json.partial! 'champions.json' }

if summoner
  json.summoner do
    json.extract! summoner, :id, :display_name, :tier, :division
  end
end
