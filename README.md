# SimpleScenerySaving
Pikey's Simple Scenery Saving & Tools script.
thebgpikester@hotmail.com 29/11/2019
You may use this how you like but I must be credited. If I find usage where no credit is obvious, I will remove you from my christmas card list and target you preferentially above others when sorting at the MELD.

REQUIRES:
MOOSE DEV from November 2019
You must de sanitise the missionscripting.lua If you do not know how to do this, I don't wish to explain it until  you have researched and understand the consequences of that action. Generally it's commonly used on servers and no issue.

USAGE:
Run a mission with moose and this script loaded
Create a markpoint with
"" nothing - will create an explosion at the location when you delete the markpoint
"tgt" + free text. Will create an entry in sceneryTgtList.lua for use later. No data validation is done so dont put a comma if building CSV's
"coord" will provide a MOOSE CORDINATE text rpelacing the marklpoint for other usage.

PRODUCTION SERVER
Comment out the bottom half of this script so users dont use the tools when in production check out the line 261 for handling actions when matching against your list

OPTIONAL:
I've commented the csv creation out. Use it if you want a CSV. If you got to here and can still read, you wont have any problems readjusting the CSV format.


