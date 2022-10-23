 local lunajson = require "lunajson" -- luarocks install lunajson

_G.ASTEROID_SIZE =  100
_G.show_debugging = false
_G.destroy_ast = false

function _G.calculateDistance(x1, y1, x2, y2)
  local dist_x = (x2 - x1) ^ 2
  local dist_y = (y2 - y1) ^ 2
  return math.sqrt(dist_x + dist_y)
end

-- function calculateDistance(x1, y1, x2, y2)
--   return math.sqrt(((x2 - x1) ^ 2) + ((y2 - y1) ^ 2))
-- end

--[[ 
    DESCRIPTION
    Read a json file and return the contents as a lua table. This function will automatically search inside the data/ folder and add a '.json' to the file name.
    PARAMETERS
    -> file_name: string - name of file to read (required)
        example: "save"
        description: Will search for 'data/save.json'
 ]]
function _G.readJSON(file_name) --this needs to ne installed with luarocks
  local file = io.open("src/data/" .. file_name .. ".json", "r")
  local data = file:read("*all")
  file:close()

  return lunajson.decode(data)
end

--[[ 
    DESCRIPTION
    Convert a table to JSON and save it in a file. This will overwrite the file if it already exists. This function will automatically search inside the data/ folder and add a '.json' to the file name.
    PARAMETERS
    -> file_name: string - name of file to write to (required)
        example: "save"
        NB: Will search for 'data/save.json'
    -> data: table - table to be converted to JSON and saved. (required)
        example: { name = "max" }
 ]]
 function _G.writeJSON(file_name, data)  -- added a method to write json
  print(lunajson.encode(data))
  local file = io.open("src/data/" .. file_name .. ".json", "w")
  file:write(lunajson.encode(data))
  file:close()
end