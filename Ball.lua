--[[
    CS50 2D
    Pong Remake

    -- Ball Class --

    Author: Colton Ogden
    cogden@cs50.harvard.edu

    Represents a ball which will bounce back and forth between paddles
    and walls until it passes a left or right boundary of the screen,
    scoring a point for the opponent.
]]

Ball = Class{}

function Ball:init(x, y, width, height)
    self.x = x
    self.y = y
    self.width = width
    self.height = height

    -- these variables are for keeping track of our velocity on both the
    -- X and Y axis, since the ball can move in two dimensions
    self.dy = 0
    self.dx = 0

    -- power-hit state
    self.powered = false
    self.powerOwner = nil
    self.trail = {}
end

--[[
    Expects a paddle as an argument and returns true or false, depending
    on whether their rectangles overlap.
]]
function Ball:collides(paddle)
    -- first, check to see if the left edge of either is farther to the right
    -- than the right edge of the other
    if self.x >= paddle.x + paddle.width or paddle.x >= self.x + self.width then
        return false
    end

    -- then check to see if the bottom edge of either is higher than the top
    -- edge of the other
    if self.y >= paddle.y + paddle.height or paddle.y >= self.y + self.height then
        return false
    end

    -- if the above aren't true, they're overlapping
    return true
end

--[[
    Places the ball in the middle of the screen, with no movement.
]]
function Ball:reset()
    self.x = VIRTUAL_WIDTH / 2 - 2
    self.y = VIRTUAL_HEIGHT / 2 - 2
    self.dx = 0
    self.dy = 0
    self.powered = false
    self.powerOwner = nil
    self.trail = {}
end

function Ball:update(dt)
    self.x = self.x + self.dx * dt
    self.y = self.y + self.dy * dt

    if self.powered then
        table.insert(self.trail, { x = self.x, y = self.y })
        if #self.trail > 12 then
            table.remove(self.trail, 1)
        end
    end
end

function Ball:activatePower(owner)
    self.powered = true
    self.powerOwner = owner
    self.trail = {}
end

function Ball:clearPower()
    self.powered = false
    self.powerOwner = nil
    self.trail = {}
end

function Ball:render()
    if self.powered then
        for i = 1, #self.trail do
            local alpha = (i / #self.trail) * 0.7
            love.graphics.setColor(1, 1, 0, alpha)
            local point = self.trail[i]
            love.graphics.rectangle('fill', point.x, point.y, self.width, self.height)
        end
        love.graphics.setColor(1, 1, 0, 1)
    else
        love.graphics.setColor(1, 1, 1, 1)
    end

    love.graphics.rectangle('fill', self.x, self.y, self.width, self.height)
    love.graphics.setColor(1, 1, 1, 1)
end
