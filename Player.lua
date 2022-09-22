---@diagnostic disable: lowercase-global

local love = require "love"

function Player(debugging)
  local SHIP_SIZE = 30
  local VIEW_ANGLE = math.rad(90)

  debugging = debugging or false

  return {
    x = love.graphics.getWidth() / 2,
    y = love.graphics.getHeight() / 2,
    radius = SHIP_SIZE / 2,
    angle = VIEW_ANGLE,
    rotation = 0,
    thrusting = false,
    thrust = {
      x = 0,
      y = 0,
      speed = 0
    },

    draw = function (self)
      local opacity = 1

      if debugging then
        love.graphics.setColor(1, 0, 0)

        love.graphics.rectangle("fill", self.x - 1, self.y - 1, 2, 2)

        love.graphics.circle("line", self.x, self.y, self.radius)
      end
      love.graphics.setColor(1, 1, 1, opacity)

      love.graphics.polygon(
        "line",
        self.x + ((4 / 3) * self.radius) * math.cos(self.angle),
        self.y - ((4 / 3) * self.radius) * math.sin(self.angle),
        self.x - self.radius * (2 / 3 * math.cos(self.angle) + math.sin(self.angle)),
        self.y + self.radius * (2 / 3 * math.sin(self.angle) - math.cos(self.angle)),
        self.x - self.radius * (2 / 3 * math.cos(self.angle) - math.sin(self.angle)),
        self.y + self.radius * (2 / 3 * math.sin(self.angle) + math.cos(self.angle))
      )
    end,

    movePlayer = function (self)
      local FPS = love.timer.getFPS()
      local friction = 0.7
    
      self.rotation = 360 / 180 * math.pi / FPS
    
      if love.keyboard.isDown("a") or love.keyboard.isDown("left") or love.keyboard.isDown("kp4") then
        self.angle = self.angle + self.rotation
      end
    
      if love.keyboard.isDown("s") or love.keyboard.isDown("right") or love.keyboard.isDown("kp6") then
        self.angle = self.angle - self.rotation
      end
    end
  }
end

return Player