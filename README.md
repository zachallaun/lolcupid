Riot API Challenge
===========
The **BIG** idea: A website that helps Summoners find new Champions by using champion mastery points. Champion mastery points are a reflection on a Summoners passion for that champion. By analyzing many summoners and finding which champions often have high mastery by the same summoner, we can gain insight into which champions complement each others play style. Unlike [other services](http://lolrecommender.com/), which tag champions with descriptions of their skill set, we can recommend champions across roles and those that capture some sort of *je ne sais quoi* that just can't be characterized.

Some designer goals:

- Ease of use (simplicity)
    - Minimal use of text boxes, form completion dropdowns
    - Obvious intent with minimal explanation
- Attractive design
    - Simple, flat design
    - Minimal landing page
    - Fun, memorable logo
- Lighthearted/humorous atmosphere
    - Don't take it too seriously. But don't let it detract from the design
    - Memes? Let's hope so
- A beautiful code base
    - Modularity
    - Good documentation


Important links
===========
[The blog post](http://na.leagueoflegends.com/en/news/community/contests/riot-games-api-challenge-2016?ref=rss)
[The challenge rules](https://developer.riotgames.com/discussion/announcements/show/eoq3tZd1)

[The API](https://developer.riotgames.com/api/methods)

[Past winners (2014)](http://na.leagueoflegends.com/en/news/community/contests/riot-games-api-challenge-winners)
[Past winners (2015)](http://na.leagueoflegends.com/en/news/community/contests/riot-games-api-challenge-20-winners)

The Stack
===========

The Algorithms
===========
##Sampling
##Devotion determination
##Correlation determination


LolCupid
===========
LolCupid's advanced matching algorithm is designed to find a true connection between *Summoner* and *Champion*. We take a quick look through your profile and champion mastery points and find a champion you're going to love!

Copy OkCupid logo?




**Notes from brainstorm:**

Champion
=========
- ip/rp values
- icon
- date since release

Summoner
=========
- All champions mastery values



Data
=========
summoner
---------
Mastery rate = mastery points per day since the champion was released (or mastery was introduced)
Devotion level = champions mastery rate / total mastery rate
Weighted devotion level = devotion level / total mastery points

champion
---------
--- all of these should be weighted by total mastery points (an indicator of how much you play)
Global interest = mastery points for champ / total mastery points for all champs
Global devotion = the sum of all the devotion for champ / total devotion
Fanaticism level = of the people who have have champ in top ten, what is the average devotion relative to other champs


Features
==========
recommendations
---------
by champion X = look at all summoners, find their weighted devotion level for X, then go through each champ and multiply those devotion levels by their devotion for X, then sum across all summoners, present the top 5
by role = tag the champ with their roles. present top five with that tag
composite recommendation (by summoner) = (by chapion x array for 150 champs), get that array for your top 5 (or represent most of ~90% of your devotion), sum up the arrays weighted by your devotion.
composite recommendation (by champ) = like by summoner, but weight all you choose evenly










summoner
========
uw_mastery_points      # total mastery points for a summoner
mastery_points         # sum of all weighted_champion_points


champion_mastery
========
summoner_id
champion_id
uw_champion_points          # points for a particular champion
champion_points             # uw_champion_points * (days mastery has been released / days since champion has been released)
uw_devotion                 # champion_points / summoner mastery_points          -- we don't need to store this
devotion                    # champion_points / avg summoner mastery_points      -- this accounts for players who don't play much
                            # uw_devotion * (summoner mastery_points / avg summoner mastery_points)

champion
========
release_date        # or the date mastery started


recommendations
========
recommendations(champion X):
    devotion_array(S) -> [devotion(S, X) for all champions X]
    devotion_array(X, S) = devotion_array(S) * devotion_level(X, S)
    sum devotion_array(X, S) for all summoners S

recommendations(champions X1..XN, W1..WN (weights)):
    all_recs = [recommendations(X) * W for champions zip(X1..XN, W1..WN)]
    sum all_recs

recommendations(summoner S):
    XS = get top N champions sorted by devotion
    recommendations(XS, [devotion(X) / sum(XS->devotion) for X in XS])

recommendations(champions X1..XN):
    recommendations(XS, 1/N)







new
======
devotion - should be positive or negative and sum to zero

preference(s, x) = champion_points(s, x) / mastery_points(s)
uw_devotion(s, x) = preference(s, x) - (1 / champs_played(s))
                  = (champion_points(s, x) - (mastery_points(s) / champs_played(s))) / mastery_points(s)
devotion = uw_devotion * (summoner mastery_points / avg summoner mastery_points)
