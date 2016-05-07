RiotClient
===========
- change line 113 of RiotClient to `URI.encode_www_form_component(args[arg_n])`
- not thread-safe at all


Homepage
===========
- get a logo
- hovering on drop down should have href cursor


Recommendation page
==========
selection side bar
---------------

selection window
-----------------
- Center the selector panel
- make scrollbar look good in all browsers

summoner
-----------
- Redirect back to homepage with a flash message if unable to load summoner (incorrect name, region, error from Riot server, etc.)

rec side bar
----------------
- + sign to add champs like x on selections

overview panel
----------------
- find better place for links


Databases
==========
- from_api does the role of updating, which means default values need to be reset inside of it, which seems out of line. Pull doesn't quite do what the name implies

Mockup
==========
- what should go in the finished champion selector area


About page
==========
- Write about the tech: doc/about_tech.txt


Other documentation
==========
- More detailed setup: doc/setup_basic.txt
- Improve readme: README.md
