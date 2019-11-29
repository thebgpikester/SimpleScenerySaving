--Pikey's Simple Scenery Saving & Tools script.
--thebgpikester@hotmail.com 29/11/2019
--You may use this how you like but I must be credited. If I find usage where no credit is obvious, I will remove you from
--my christmas card list and target you preferentially above others when sorting at the MELD.

--REQUIRES:
--MOOSE DEV from November 2019
--You must de sanitise the missionscripting.lua If you do not know how to do this, I don't wish to explain it until 
--you have researched and understand the consequences of that action. Generally it's commonly used on servers and no issue.

--USAGE:
--Run a mission with mosse and this script loaded
--Create a markpoint with
--"" nothing - will create an explosion at the location when you delete the markpoint
--"tgt" + free text. Will create an entry in sceneryTgtList.lua for use later. No data validation is done so dont put a comma if building CSV's
--"coord" will provide a MOOSE CORDINATE text rpelacing the marklpoint for other usage.

--PRODUCTION SERVER
--Comment out the bottom half of this script so users dont use the tools when in production
--check out the line 261 for handling actions when matching against your list

--OPTIONAL:
--I've commented the csv creation out. Use it if you want a CSV. If you got to here and can still read, you
--wont have any problems readjusting the CSV format.



csvFilePath = "E:\\DCS World OpenBeta\\db.csv" --edit this to represent your own (DCS cant write to different disks)

--http://lua-users.org/wiki/SaveTableToFile

   local function exportstring( s )
      return string.format("%q", s)
   end

   --// The Save Function
   function table.save(  tbl,filename )
      local charS,charE = "   ","\n"
      local file,err = io.open( filename, "w+" ) --edited
      if err then return err end

      -- initiate variables for save procedure
      local tables,lookup = { tbl },{ [tbl] = 1 }
      file:write( "return {"..charE )

      for idx,t in ipairs( tables ) do
         file:write( "-- Table: {"..idx.."}"..charE )
         file:write( "{"..charE )
         local thandled = {}

         for i,v in ipairs( t ) do
            thandled[i] = true
            local stype = type( v )
            -- only handle value
            if stype == "table" then
               if not lookup[v] then
                  table.insert( tables, v )
                  lookup[v] = #tables
               end
               file:write( charS.."{"..lookup[v].."},"..charE )
            elseif stype == "string" then
               file:write(  charS..exportstring( v )..","..charE )
            elseif stype == "number" then
               file:write(  charS..tostring( v )..","..charE )
            end
         end

         for i,v in pairs( t ) do
            -- escape handled values
            if (not thandled[i]) then
            
               local str = ""
               local stype = type( i )
               -- handle index
               if stype == "table" then
                  if not lookup[i] then
                     table.insert( tables,i )
                     lookup[i] = #tables
                  end
                  str = charS.."[{"..lookup[i].."}]="
               elseif stype == "string" then
                  str = charS.."["..exportstring( i ).."]="
               elseif stype == "number" then
                  str = charS.."["..tostring( i ).."]="
               end
            
               if str ~= "" then
                  stype = type( v )
                  -- handle value
                  if stype == "table" then
                     if not lookup[v] then
                        table.insert( tables,v )
                        lookup[v] = #tables
                     end
                     file:write( str.."{"..lookup[v].."},"..charE )
                  elseif stype == "string" then
                     file:write( str..exportstring( v )..","..charE )
                  elseif stype == "number" then
                     file:write( str..tostring( v )..","..charE )
                  end
               end
            end
         end
         file:write( "},"..charE )
      end
      file:write( "}" )
      file:close()
   end
   
   --// The Load Function
   function table.load( sfile )
      local ftables,err = loadfile( sfile )
      if err then return _,err end
      local tables = ftables()
      for idx = 1,#tables do
         local tolinki = {}
         for i,v in pairs( tables[idx] ) do
            if type( v ) == "table" then
               tables[idx][i] = tables[v[1]]
            end
            if type( i ) == "table" and tables[i[1]] then
               table.insert( tolinki,{ i,tables[i[1]] } )
            end
         end
         -- link indices
         for _,v in ipairs( tolinki ) do
            tables[idx][v[2]],tables[idx][v[1]] =  tables[idx][v[1]],nil
         end
      end
      return tables[1]
   end
-- close do

     
function table.val_to_str ( v )
  if "string" == type( v ) then
    v = string.gsub( v, "\n", "\\n" )
    if string.match( string.gsub(v,"[^'\"]",""), '^"+$' ) then
      return "'" .. v .. "'"
    end
    return '"' .. string.gsub(v,'"', '\\"' ) .. '"'
  else
    return "table" == type( v ) and table.tostring( v ) or
      tostring( v )
  end
end

function table.key_to_str ( k )
  if "string" == type( k ) and string.match( k, "^[_%a][_%a%d]*$" ) then
    return k
  else
    return "[" .. table.val_to_str( k ) .. "]"
  end
end
function table.tostring( tbl )
  local result, done = {}, {}
  for k, v in ipairs( tbl ) do
    table.insert( result, table.val_to_str( v ) )
    done[ k ] = true
  end
  for k, v in pairs( tbl ) do
    if not done[ k ] then
      table.insert( result,
        table.key_to_str( k ) .. "=" .. table.val_to_str( v ) )
    end
  end
  return "{" .. table.concat( result, "," ) .. "}"
end



function file_exists(name) --check if the file already exists for writing
    if lfs.attributes(name) then
    return true
    else
    return false end 
end


--this doesnt seem to work as expected.
function rngsmoke(vec3)

local roll = math.random(1,100)
if roll > 95 then
vec3:BigSmokeHuge(0.1)
elseif roll < 10 then
vec3:BigSmokeMedium(0.2)
end

end


--thanks Shadowze
function table_has_key(tab, key_val)
    for key, value in pairs(tab) do
        -- env.info(" key is " .. key.. "   key_val is ".. key_val ) 
        if key == key_val then
            return true
        end
    end
    return false
end



function round(num, numDecimalPlaces)
  local mult = 10^(numDecimalPlaces or 0)
  return math.floor(num * mult + 0.5) / mult
end

function writeCSV(data, file)
  File = io.open(file, "a")
  File:write(data)
  File:close()
end
-----------------------------------------------
--SCRIPT
-----------------------------------------------


maxSceneryCount = 500

--CHECKING FOR PREVIOUS FILE OF ALL DESTROYED SCENERY
if file_exists("sceneryPersistence.lua") then
  scenery = table.load("sceneryPersistence.lua")
  env.info("Scenery file loaded")
      for i = 2,#scenery do
       local vec3 = COORDINATE:New(scenery[i].x, scenery[i].y, scenery[i].z)
       vec3:Explosion(2000) --This is not always enough to blow up something and is also sometimes too much.
       rngsmoke(vec3)
      end
else
  scenery = {}
  env.info("New Scenery file from scratch")
end


--CHECKING FOR PREVIOUS TARGET LIST FILE
if file_exists("sceneryTgtList.lua") then
  savedSceneryTbl = table.load("sceneryTgtList.lua")
  env.info("Saved scenery check list loaded")
else
  savedSceneryTbl={}
  env.info("Empty target list, writing new file")
  table.save(scenery, "sceneryPersistence.lua")
end




EH = EVENTHANDLER:New()
EH:HandleEvent( EVENTS.Dead ) --this is a popular handler. Ensure you do not duplicate.

function EH:OnEventDead( EventData )
         if EventData.IniUnit and EventData.IniObjectCategory==Object.Category.SCENERY then
          local coord=EventData.IniUnit:GetVec3()  
          table.insert(scenery,coord)
          --we check the event scenery that died against the file of items we built
            if table_has_key(savedSceneryTbl, EventData.IniUnitName) == true then --items below this line will execute when finding the item on the list
              savedSceneryTbl[EventData.IniUnitName]=nil --add date?
             --MESSAGE:New("You destroyed the target!", 20):ToAll()
             --uncomment above if you want a custom message
            end
          end
end



SCHEDULER:New( nil, function()
table.save(scenery, "sceneryPersistence.lua")--this is scenery persistence, nothing to do with targets
--env.info(#savedSceneryTbl .." targets left")


--The section below creates a CSV file from the table. This is optional and I've commented it out. It might be useful to you if
--you use CSV's for something to do with databases/web


--[[
local data="ID,DESCRIPTION,MGRS,DDM,DMS,ALT,LINK\n"
os.remove(csvFilePath) --delete entire thing because finding file lines is more complex for me and all we do is delete an entry at a time
 writeCSV(data,csvFilePath) 
 for k,v in pairs (savedSceneryTbl) do
  writeCSV(v,csvFilePath)
 end
--]]

end, {},2, 20)
------------------------------------------
--END OF PRODUCTION SCRIPT
------------------------------------------
--COMMENT OUT THE REMAINDER FOR PRODUCTION
------------------------------------------
------------------------------------------
------------------------------------------

-------
--TOOLS
-------

function sceneryList(coord,radius, text)

count = 0
_,_,_,unitstable,staticstable,scenerytable=coord:ScanObjects(radius, false, false, true)
for index, SceneryID in pairs(scenerytable) do
    count = count + 1
      if count > maxSceneryCount then
        MESSAGE:New("Max returned scenery exceeded, consider lowering the range.",20):ToAll()
        --break
      else
        local SceneryObject = SCENERY:Register(SceneryID:getTypeName(), SceneryID)
        local scenCoord = SceneryObject:GetCoordinate()
        local MarkID = scenCoord:MarkToAll(  SceneryObject:GetName() .. "   " .. scenCoord:ToStringMGRS() .. " ALT " .. round(scenCoord:GetLandHeight(),0) .. " M" )
        savedSceneryTbl[SceneryID.id_]=SceneryID.id_..","..text.." appears like a " ..SceneryObject:GetName() .. ", ".. scenCoord:ToStringMGRS() ..", " .. scenCoord:ToStringLLDDM() .. ", " .. scenCoord:ToStringLLDMS() .. ", ALT " .. round(scenCoord:GetLandHeight(),0) .. " METRES\n" 
      end

end


MESSAGE:New("Found ".. count .." scenery items within " .. radius .. " Metres",20):ToAll()
radius=nil
end




EH1 = EVENTHANDLER:New()
EH1:HandleEvent(EVENTS.MarkRemoved)

function EH1:OnEventMarkRemoved(EventData)

         if EventData.text == "" then
            explode(EventData.MarkCoordinate, EventData.MarkID)
         elseif EventData.text:lower():find("coord") then
            coords(EventData.MarkCoordinate, EventData.MarkID) 
         elseif EventData.text:lower():find("tgt") then
             sceneryList(EventData.MarkCoordinate, 3, EventData.text)
         else
            MESSAGE:New("The Marker text must be 'coord' 'tgt' or empty", 5):ToAll()
         end
         
         end


function explode(coord, markID)

         coord:Explosion(5400)
end




function coords(coord, markID)

         local _MarkID = coord:MarkToAll("changeMe = COORDINATE:New("..coord.x..", "..coord.y..", "..coord.z..")")
end

SCHEDULER:New( nil, function()
table.save(savedSceneryTbl, "sceneryTgtList.lua")
end, {},1, 10)