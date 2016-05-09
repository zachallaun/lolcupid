json.champions do
  json.partial! 'champions.json'
end

json.random_splash_url Champion.random_splash
