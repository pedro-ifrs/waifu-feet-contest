local Button = {}
Button.__index = Button

function Button.new(x, y, width, height, text, callback)
    local self = setmetatable({}, Button)
    self.x = x
    self.y = y
    self.width = width
    self.height = height
    self.text = text
    self.callback = callback
    self.hovered = false
    return self
end

function Button:draw(colors, fonts)
    local color = self.hovered and colors.pink or colors.white
    love.graphics.setColor(color)
    love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
    love.graphics.setColor(colors.black)
    love.graphics.rectangle("line", self.x, self.y, self.width, self.height)
    
    love.graphics.setColor(colors.black)
    local textWidth = fonts.normal:getWidth(self.text)
    local textHeight = fonts.normal:getHeight()
    love.graphics.print(self.text, self.x + (self.width - textWidth) / 2, self.y + (self.height - textHeight) / 2)
end

function Button:update(mx, my)
    self.hovered = mx >= self.x and mx <= self.x + self.width and my >= self.y and my <= self.y + self.height
end

function Button:click(mx, my)
    if self.hovered and self.callback then
        self.callback()
    end
end

return Button
