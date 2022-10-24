-- https://www.youtube.com/watch?v=I549C6SmUnk&t=37867s
---@diagnostic disable: lowercase-global

require "globals"

local love = require "love"

local Player = require "objects/Player"
local Game = require "states/Game"
local Menu = require "states/Menu"
local SFX = require "components/SFX"

local reset_complete = false

math.randomseed(os.time())

local function reset()
  local save_data = _G.readJSON("save")

  sfx = SFX()

  player = Player(3, sfx)
  game = Game(save_data, sfx)
  menu = Menu(game, player, sfx)
  destroy_ast = false
end

function love.load()
  love.mouse.setVisible(false)

  _G.mouse_x, _G.mouse_y = 0, 0

  -- local show_debugging = true

  reset()

  sfx.playBGM()
end

-- keys
function love.keypressed(key)
  if game.state.running then
    if key == "w" or key == "up" or key == "kp8" then
        player.thrusting = true
    end

    if key == "space" or key == "down" or key == "kp5" then
      player:shootLaser()
    end

    if key == "escape" then
      game:changeGameState("paused")
    end
  elseif game.state.paused then
    if key == "escape" then
      game:changeGameState("running")
    end
  end
end

function love.keyreleased(key)
  if key == "w" or key == "up" or key == "kp8" then
      player.thrusting = false
  end
end

function love.mousepressed(x, y, button, istouch, presses)
  if button == 1 then
    if game.state.running then
      player:shootLaser()
    else
      clickedMouse = true
    end
  end
end
-- keys end

function love.update(dt)
  _G.mouse_x, _G.mouse_y = love.mouse.getPosition()

  if game.state.running then
    player:movePlayer(dt)

    for ast_index, asteroid in pairs(_G.asteroids) do
      if not player.exploading and not player.invincible then
        if _G.calculateDistance(player.x, player.y, asteroid.x, asteroid.y) < player.radius + asteroid.radius then
          player:expload()
          destroy_ast = true
        end
      else
        player.expload_time = player.expload_time - 1

        if player.expload_time == 0 then
          if player.lives - 1 <= 0 then
            game:changeGameState("ended")
            return
          end

          player = Player(player.lives - 1, sfx)
        end
      end
      
      for _, laser in pairs(player.lasers) do
        if _G.calculateDistance(laser.x, laser.y, asteroid.x, asteroid.y) < asteroid.radius then
          laser:expload()
          asteroid:destroy(_G.asteroids, ast_index, game)
        end
      end

      -- Hay que esperar un poco al colisionar por 3ra vez con el asteroide
      -- y prevenir que el último asteroide desaparezca en esa colisión
      -- para prevenir un bug aparentemente, eso dice el tutorial.
      -- Sería imposible perder la última vida y al mismo tiempo pasar de nivel
      if destroy_ast then
        if player.lives - 1 <= 0 then
          if player.expload_time == 0 then
            destroy_ast = false
            asteroid:destroy(_G.asteroids, ast_index, game)
          end
        else
          destroy_ast = false
          asteroid:destroy(_G.asteroids, ast_index, game)
        end
      end

      asteroid:move(dt)
    end

    if #_G.asteroids == 0 then
      game.level = game.level + 1
      game:startNewGame(player)
    end
  elseif game.state.menu then
    menu:run(clickedMouse)
    clickedMouse = false

    if not reset_complete then
      reset()
      reset_complete = true
    end
  elseif game.state.ended then
    reset_complete = false
  end
end

function love.draw()
  if game.state.running or game.state.paused then
    player:drawLives(game.state.paused)
    player:draw(game.state.paused)

    for _, asteroid in pairs(_G.asteroids) do
      asteroid:draw(game.state.paused)
    end
    
    game:draw(game.state.paused)
  elseif game.state.menu then
    menu:draw()
  elseif game.state.ended then
    game:draw()
  end

  love.graphics.setColor(1, 1, 1, 1)

  if not game.state.running then
    love.graphics.circle("fill", mouse_x, mouse_y, 10)
  end

  love.graphics.print(love.timer.getFPS(), 10, 10)
end