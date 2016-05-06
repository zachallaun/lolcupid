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
- fix spacing in the last row of the selector
- clicking a greyed out champion should remove it from the picks


Databases
==========
- from_api does the role of updating, which means default values need to be reset inside of it, which seems out of line. Pull doesn't quite do what the name implies

Mockup
==========
- what should go in the finished champion selector area


About page
==========
- Write about the math: doc/about_math.txt
    - Figure out mathjax
- Write about the tech: doc/about_tech.txt


Other documentation
==========
- More detailed setup: doc/setup_basic.txt
- Improve readme: README.md
