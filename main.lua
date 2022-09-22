-- https://youtu.be/I549C6SmUnk?t=20115
---@diagnostic disable: lowercase-global

local love = require "love"

local Player = require "Player"

function love.load()
  love.mouse.setVisible(false)
  _G.mouse_x, _G.mouse_y = 0, 0

  local show_debugging = true

  player = Player(show_debugging)
end

function love.update()
  _G.mouse_x, _G.mouse_y = love.mouse.getPosition()
end

function love.draw()
  player:draw()
end