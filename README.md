Pikey's Simple Scenery Saving & Tools script, 29/11/2019, updated Feb 2023

Changes; fixed miz, fix scripts reeference to some things that went unused, removed csv parts and re-validated testing
DESCRIPTION:
This script can help you use scenery in your missions by tracking what got blown up and copying that at the start of the next mission post restart. This script can also capture coordinates at point and the scenery id which is helpful in mission building and design. (Note that ED released multiple viewable coordinates since 2019 so that part is not as useful but it still allows you to do it faster and automate)

You can also go through a map and click on scenery in the game world and test to see if it blows up correctly, what ID and description it has and even build a file of target lists. A sample output to file on one click of a control tower at Kobuleti gives:
[129337049]="129337049,tgt Control Tower appears like a KDP, MGRS 37T GG 37237 46133, LL DDM 041° 55.891'N   041° 51.683'E, LL DMS 041°55'53.490\"N 041°51'40.988\"E, ALT 18 METRES\
the number 129337049 is the id, you can use this with a "dead event". You get the same from right clicking in mission editor.
'tgt Control Tower' is the text entered to the markpoint
"Appears like a "...
"KDP" is the model name in game, often is in Russian and not unique in most cases (hence we need a free text comment)
Coordinates in MGRS, DDM, DMS and altitude.

REQUIRES:
MOOSE (any version post 2019)
You must de sanitise the missionscripting.lua because the script will need to write a file full of scenery for the persistence between misison restarts

MISSION PLAY USAGE:
You want to Persist your dead scenery (Read second use case for identifying scenery and tools)
Run a mission with MOOSE and this script loaded
Do nothing else, play as normal. If any scenery is destroyed it is recorded in a file in your DCS directory called
SceneryPersistence.lua
This file contains a list of coordinates where scenery was destroyed. At the start of the next mission, assuming the file is intact and this script is run
the scenery is blown up again by going through those coordinates and creating an explosion. Some may have optional smoke added.

TOOLS USAGE:
You want to record scenery locations for briefings and such. When the mission is running, open the F10 map and create a Markpoint on a scenery object
You can create 3 different types of markpoints
empty - if you create a markpoint with no text in it, by default it will create an explosion at the location when you delete the markpoint. 
This is useful for seeing how the scenery explodes or if at all, since some buildings are immortal for reasons known to ED. 
"tgt" + text. Will create an entry in a file in your DCS directory called 'sceneryTgtList.lua' for use later. The free text after the target should describe the building so you can refer to it later
No data validation is done so dont put a comma if building CSV's
"coord". When you delete a markpoint with "coord" written in it, a new replacement markpoint will appear with the model name, MGRS coordinates and altitude

PRODUCTION SERVER
Comment out the bottom half of this script if you don't want users to have access to the tools like exploding markpoints.
