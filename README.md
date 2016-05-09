# LoLCupid

[LoLCupid](http://www.lolcupid.me) is a champion recommendation engine created for the [April 2016 Riot Games API Challenge](https://developer.riotgames.com/discussion/announcements/show/eoq3tZd1). The goal of the API Challenge was to:

> Submit a piece of software that utilizes Champion Mastery data which excels primarily in one of the following categories:
>
> 1. Entertainment
> 2. Usability/Practicality
> 3. Creativity/Originality

We chose to focus on *usability/practicality*, and created a tool that offers champion recommendations based on what you and thousands of other Summoners have already mastered. Are you a Wukong one-trick-pony looking to break out of your lane? We look at other Summoners who play a ton of Wukong and provide recommendations based on the champions they've also loved.

This project was jointly created by [Troy Baker](https://github.com/rekabat) (rekabat) and [Zach Allaun](https://github.com/zachallaun) (mutinyonthebay).

## Tools and techniques

Ruby, Rails, and PostgreSQL are used on the backend to fetch and analyze Summoner and Champion Mastery data and serve recommendations. React and Redux are used on the frontend to render content and build interactive user interfaces. Heroku is used as a hosting platform.

**Data fetching and analysis.** Champion recommendations are the result of aggregating champion mastery information from thousands of Summoners; to provide quality recommendations, we must both continue to grow our dataset and keep it up-to-date. To that end, data fetching and analysis is done as a background process on an ongoing basis:

- Hourly tasks fetch new mastery information from Summoners we already know about, helping ensure we have recent match data.
- Daily tasks recompute champion recommendation scores based on our most recent mastery data. (The algorithm behind recommendations takes our entire corpus of Summoner and mastery data into account; it is a process that would take too long if repeated per-request, so we've developed it such that we can cache intermediaty results and final recommendation scores.)
- Periodic (manually kicked-off) tasks grow our set of Summoners using recent match data from those Summoners we already know about. This process uses weighted sampling to ensure that our set of Summoners has a distribution of ranked tiers comparable to that of the entire playerbase (though we do sample Challenger and Master players disproportionately).

**User interface.** To convey results, we focused on creating a user experience that was simple, familiar, and compelling. We took cues from some of our favorite existing tools to create a set of UI elements that we hope League players will immediately understand.

Building up a team of champions using a Champion Select-inspired interface dynamically updates the set of recommendations you see on the right. We break it down by lane, highlighting the strongest recommendation and providing four secondary recommendations.

![champion select](http://i.imgur.com/h4D7SlN.png)

Hovering over one of our recommendations drops the Champion Select menu, providing an overview of that champion's abilities and some helpful links to learn more should you choose to try them out.

![champion overview](http://i.imgur.com/bTzcaQH.png)

Searching by Summoner name removes the Champion Select widget, offering recommendations tailored to that Summoner. Instead of weighting all of the input champions equally, we weight recommendations based on what the Summoner plays most. While it's fun to see how recommendations change as you add and remove champions, searching by Summoner will offer the best personalized recommendations.

![summoner recommendations](http://i.imgur.com/uldWeJ8.png)

## Running the code

`bin/setup`


## Data Collection
Integral to the application is a large collection of summoners on which to base the recommendations. Our collection of summoners on live is ~90k, coming from both the NA servers and EUW. Collecting this data was not a trivial task, and the script `app/services/gen_ids.rb` is interesting independent of the rest of the application. It first requires a seed of summoner names collected manually; we used ourselves, our friends, and some pros. Next we grow the database by selecting a random summoner already in the database and adding all of the summoners in their past ten matches (we only wanted players active since champion mastery came out.)

However, we also wanted the database to be approximately balanced by ranked tier, based on the assumption that this would give the most well-rounded recommendations. We found a breakdown of tiers from a third party source and manually added this to the script. Instead of randomly drawing from the database every time we wanted to grow, we determined the distribution of our database by tier and selected a summoner from the tier with the least summoners relative to the true distribution. Since people in a tier tend to play against summoners also in their tier, over a large number of samples this resulted in a well-balanced database.



# README TODOs

- Talk about experience implementing the recommendation algorithm, how it was too slow at first until we moved it all into the database and cached intermediary values and final recommendation scores.





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
