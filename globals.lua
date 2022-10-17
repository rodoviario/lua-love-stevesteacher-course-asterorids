 local lunajson = require "lunajson"

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

function readJSON(file_name)
  local file = io.open("src/data/" .. file_name .. ".json", "r")
  local data = file:read("*all")
  file:close()

  return lunajson.decode(data);
end