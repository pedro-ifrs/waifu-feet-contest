local AssetManager = {}

local fonts = {
    title = nil,
    normal = nil,
    small = nil
}

local colors = {
    white = {1, 1, 1, 1},
    black = {0, 0, 0, 1},
    red = {1, 0, 0, 1},
    blue = {0, 0.5, 1, 1},
    green = {0, 1, 0, 1},
    gray = {0.5, 0.5, 0.5, 1},
    pink = {1, 0.7, 0.8, 1}
}

local images = {}
local sounds = {}

function AssetManager.loadFonts()
    fonts.title = love.graphics.newFont(32)
    fonts.normal = love.graphics.newFont(16)
    fonts.small = love.graphics.newFont(12)
end

function AssetManager.loadImages()
    -- Create placeholder images for each waifu
    -- In a real game, these would be actual image files
    
    for i = 1, 5 do
        -- Create a colored rectangle as placeholder for each waifu
        local image = love.graphics.newCanvas(200, 200)
        love.graphics.setCanvas(image)
        
        -- Different colors for each waifu
        local waifuColors = {
            {1, 0.2, 0.2}, -- Red
            {0.2, 1, 0.2}, -- Green  
            {0.2, 0.2, 1}, -- Blue
            {1, 1, 0.2},   -- Yellow
            {1, 0.2, 1}    -- Magenta
        }
        
        love.graphics.setColor(waifuColors[i][1], waifuColors[i][2], waifuColors[i][3])
        love.graphics.rectangle("fill", 0, 0, 200, 200)
        love.graphics.setColor(0, 0, 0)
        love.graphics.rectangle("line", 0, 0, 200, 200)
        love.graphics.setColor(1, 1, 1)
        love.graphics.printf("Waifu" .. i, 0, 80, 200, "center")
        
        love.graphics.setCanvas()
        images[i] = image
    end
end

function AssetManager.loadSounds()
    -- Create placeholder sounds using LÖVE\'s built-in sound generation
    -- In a real game, these would be actual sound files
    
    -- For now, we\'ll use placeholder sound objects
    -- The actual sound playing will be handled in the click functions
    sounds.yesBaby = "yes_baby_sound" -- Placeholder
    sounds.ohNoBaby = "oh_no_baby_sound" -- Placeholder  
    sounds.plim = "plim_sound" -- Placeholder
end

function AssetManager.getFont(name)
    return fonts[name]
end

function AssetManager.getColor(name)
    return colors[name]
end

function AssetManager.getImage(index)
    return images[index]
end

function AssetManager.getSound(name)
    return sounds[name]
end

function AssetManager.playSound(soundName)
    -- Placeholder for sound playing
    -- In a real game, you would use: gameData.sounds[soundName]:play()
    print("Playing sound: " .. soundName)
end

function AssetManager.getColors()
    return colors
end

function AssetManager.getFonts()
    return fonts
end

return AssetManager
