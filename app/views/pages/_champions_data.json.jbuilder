json.partial! 'recommendations.json', query_champions: query_champions, recommendations: recommendations

json.champions { json.partial! 'champions.json' }
