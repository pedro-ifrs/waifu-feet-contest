local ScreenRenderer = {}

local AssetManager = require("modules.AssetManager")
local GameDataManager = require("modules.GameDataManager")
local SettingsManager = require("modules.SettingsManager")
local GameStateManager = require("modules.GameStateManager")
local Button = require("classes.Button")

-- Local references to buttons, initialized by InputHandler but needed here for drawing
local mainMenuButtons = {}
local optionsButtons = {}
local endGameButtons = {}

-- Function to set buttons from InputHandler (called during initialization)
function ScreenRenderer.setButtons(mainMenu, options, endGame)
    mainMenuButtons = mainMenu
    optionsButtons = options
    endGameButtons = endGame
end

function ScreenRenderer.drawMainMenu()
    love.graphics.setFont(AssetManager.getFont("title"))
    love.graphics.setColor(AssetManager.getColor("pink"))
    love.graphics.printf("Waifu Feet Contest", 0, 100, 800, "center")
    
    love.graphics.setFont(AssetManager.getFont("normal"))
    love.graphics.setColor(AssetManager.getColor("white"))
    love.graphics.printf("Find the winning waifu!", 0, 150, 800, "center")
    
    -- Draw buttons
    if mainMenuButtons and #mainMenuButtons > 0 then
        for _, button in ipairs(mainMenuButtons) do
            button:draw(AssetManager.getColors(), AssetManager.getFonts())
        end
    else
        -- Debug: show if buttons are not loaded
        love.graphics.setColor(AssetManager.getColor("red"))
        love.graphics.printf("Buttons not loaded! Click anywhere to continue...", 0, 200, 800, "center")
    end
end

function ScreenRenderer.drawOptions()
    love.graphics.setFont(AssetManager.getFont("title"))
    love.graphics.setColor(AssetManager.getColor("pink"))
    love.graphics.printf("Options", 0, 50, 800, "center")
    
    love.graphics.setFont(AssetManager.getFont("normal"))
    love.graphics.setColor(AssetManager.getColor("white"))
    
    -- Volume control
    love.graphics.printf("Volume: " .. math.floor(SettingsManager.getSetting("volume") * 100) .. "%", 0, 150, 800, "center")
    love.graphics.setColor(AssetManager.getColor("gray"))
    love.graphics.rectangle("fill", 250, 180, 300, 20)
    love.graphics.setColor(AssetManager.getColor("pink"))
    love.graphics.rectangle("fill", 250, 180, 300 * SettingsManager.getSetting("volume"), 20)
    love.graphics.setColor(AssetManager.getColor("black"))
    love.graphics.rectangle("line", 250, 180, 300, 20)
    
    -- Screen mode
    love.graphics.setColor(AssetManager.getColor("white"))
    love.graphics.printf("Screen Mode: " .. (SettingsManager.getSetting("fullscreen") and "Fullscreen" or "Windowed"), 0, 220, 800, "center")
    
    -- Hint toggle
    love.graphics.printf("Hints: " .. (SettingsManager.getSetting("hintsEnabled") and "On" or "Off"), 0, 250, 800, "center")
    
    -- Instructions
    love.graphics.setColor(AssetManager.getColor("gray"))
    love.graphics.printf("Click on volume bar to adjust, press F for fullscreen, press H for hints", 0, 300, 800, "center")
    
    -- Draw back button
    if optionsButtons then
        for _, button in ipairs(optionsButtons) do
            button:draw(AssetManager.getColors(), AssetManager.getFonts())
        end
    end
end

function ScreenRenderer.drawCharacterSelect()
    love.graphics.setFont(AssetManager.getFont("title"))
    love.graphics.setColor(AssetManager.getColor("pink"))
    love.graphics.printf("Character Selection", 0, 50, 800, "center")
    
    love.graphics.setFont(AssetManager.getFont("normal"))
    love.graphics.setColor(AssetManager.getColor("white"))
    love.graphics.printf("These are the ones selected for the final stage of the challenge!", 0, 100, 800, "center")
    love.graphics.printf("Let the final challenge begin...", 0, 130, 800, "center")
    
    -- Draw waifu placeholders
    for i = 1, 5 do
        local x = 100 + (i - 1) * 120
        local y = 200
        love.graphics.setColor(AssetManager.getColor("gray"))
        love.graphics.rectangle("fill", x, y, 100, 100)
        love.graphics.setColor(AssetManager.getColor("black"))
        love.graphics.rectangle("line", x, y, 100, 100)
        love.graphics.printf("Waifu" .. i, x, y + 110, 100, "center")
    end
end

function ScreenRenderer.drawMainGame()
    local gameData = GameDataManager.gameData
    love.graphics.setFont(AssetManager.getFont("normal"))
    love.graphics.setColor(AssetManager.getColor("white"))
    love.graphics.printf("Photo " .. gameData.currentPhoto .. " / " .. gameData.totalPhotos, 0, 20, 800, "center")
    
    -- Draw the actual waifu image
    local photoX = 300
    local photoY = 100
    local currentWaifu = gameData.photos[gameData.currentPhoto]
    
    if AssetManager.getImage(currentWaifu) then
        love.graphics.setColor(1, 1, 1)
        love.graphics.draw(AssetManager.getImage(currentWaifu), photoX, photoY)
    else
        -- Fallback to placeholder
        love.graphics.setColor(AssetManager.getColor("gray"))
        love.graphics.rectangle("fill", photoX, photoY, 200, 200)
        love.graphics.setColor(AssetManager.getColor("black"))
        love.graphics.rectangle("line", photoX, photoY, 200, 200)
        love.graphics.printf("Photo " .. gameData.currentPhoto, photoX, photoY + 80, 200, "center")
    end
    
    -- Instructions
    love.graphics.setColor(AssetManager.getColor("gray"))
    love.graphics.printf("Is this the winning waifu?", 0, 320, 800, "center")
    
    -- Draw buttons
    love.graphics.setColor(AssetManager.getColor("green"))
    love.graphics.rectangle("fill", 200, 400, 100, 50)
    love.graphics.setColor(AssetManager.getColor("black"))
    love.graphics.rectangle("line", 200, 400, 100, 50)
    love.graphics.printf("YES", 200, 415, 100, "center")
    
    love.graphics.setColor(AssetManager.getColor("red"))
    love.graphics.rectangle("fill", 500, 400, 100, 50)
    love.graphics.setColor(AssetManager.getColor("black"))
    love.graphics.rectangle("line", 500, 400, 100, 50)
    love.graphics.printf("NO", 500, 415, 100, "center")
    
    if SettingsManager.getSetting("hintsEnabled") then
        love.graphics.setColor(AssetManager.getColor("blue"))
        love.graphics.rectangle("fill", 350, 400, 100, 50)
        love.graphics.setColor(AssetManager.getColor("black"))
        love.graphics.rectangle("line", 350, 400, 100, 50)
        love.graphics.printf("HINT", 350, 415, 100, "center")
    end
end

function ScreenRenderer.drawHintScreen()
    local gameData = GameDataManager.gameData
    love.graphics.setFont(AssetManager.getFont("title"))
    love.graphics.setColor(AssetManager.getColor("blue"))
    love.graphics.printf("HINT", 0, 50, 800, "center")
    
    love.graphics.setFont(AssetManager.getFont("normal"))
    love.graphics.setColor(AssetManager.getColor("white"))
    
    -- Show elimination status with proper text and affection
    local possible = "The waifu can be: "
    local eliminated = "They can\\\'t be: "
    
    for i = 1, 5 do
        if gameData.waifus[i].eliminated then
            eliminated = eliminated .. gameData.waifus[i].name .. " "
        else
            local aff = gameData.waifus[i].affection
            possible = possible .. gameData.waifus[i].name .. " (affection: " .. tostring(aff) .. ") "
        end
    end
    
    love.graphics.printf(possible, 0, 120, 800, "center")
    love.graphics.printf(eliminated, 0, 150, 800, "center")
    
    -- Show deduction strategy hints
    love.graphics.setColor(AssetManager.getColor("gray"))
    love.graphics.printf("Strategy: Hearts appear when you press \\\'Yes\\\', Red flash when you press \\\'No\\\'!", 0, 200, 800, "center")
    love.graphics.printf("Use your previous answers to eliminate possibilities!", 0, 220, 800, "center")
    love.graphics.printf("Press ESC to return", 0, 260, 800, "center")
end

function ScreenRenderer.drawPreAnnouncement()
    love.graphics.setFont(AssetManager.getFont("title"))
    love.graphics.setColor(AssetManager.getColor("pink"))
    love.graphics.printf("And the winner is...", 0, 200, 800, "center")
    
    -- Face down card
    love.graphics.setColor(AssetManager.getColor("gray"))
    love.graphics.rectangle("fill", 300, 300, 200, 200)
    love.graphics.setColor(AssetManager.getColor("black"))
    love.graphics.rectangle("line", 300, 300, 200, 200)
    love.graphics.printf("???", 300, 380, 200, "center")
end

function ScreenRenderer.drawWinnerReveal()
    local gameData = GameDataManager.gameData
    love.graphics.setFont(AssetManager.getFont("title"))
    love.graphics.setColor(AssetManager.getColor("pink"))
    love.graphics.printf(gameData.waifus[gameData.winner].name .. "!", 0, 100, 800, "center")
    
    love.graphics.setFont(AssetManager.getFont("normal"))
    love.graphics.setColor(AssetManager.getColor("white"))
    love.graphics.printf("She\\\'s the most loving and caring waifu!", 0, 150, 800, "center")
    love.graphics.printf("She absolutely adores you!", 0, 180, 800, "center")
    love.graphics.printf("Fun fact: She loves long walks on the beach!", 0, 210, 800, "center")
end

function ScreenRenderer.drawRanking()
    local gameData = GameDataManager.gameData
    love.graphics.setFont(AssetManager.getFont("title"))
    love.graphics.setColor(AssetManager.getColor("pink"))
    love.graphics.printf("Final Ranking", 0, 50, 800, "center")
    
    love.graphics.setFont(AssetManager.getFont("normal"))
    love.graphics.setColor(AssetManager.getColor("white"))
    love.graphics.printf("Photos shown: " .. gameData.totalPhotos .. " total", 0, 100, 800, "center")
    
    -- Determine player\\\'s chosen winner (highest affection)
    local chosenIndex = 1
    local highestAffection = -9999
    for i = 1, 5 do
        if gameData.waifus[i].affection > highestAffection then
            highestAffection = gameData.waifus[i].affection
            chosenIndex = i
        end
    end
    
    -- Build a sorted view by affection desc
    local sorted = {}
    for i = 1, 5 do
        table.insert(sorted, {index = i, name = gameData.waifus[i].name, affection = gameData.waifus[i].affection, totalPhotos = gameData.waifus[i].totalPhotos})
    end
    table.sort(sorted, function(a, b) return a.affection > b.affection end)
    
    for rank = 1, #sorted do
        local y = 140 + (rank - 1) * 40
        local entry = sorted[rank]
        local color = AssetManager.getColor("white")
        if entry.index == gameData.winner then
            color = AssetManager.getColor("green") -- Actual winner
        elseif entry.index == chosenIndex then
            color = AssetManager.getColor("blue") -- Player\\\'s guess
        end
        love.graphics.setColor(color)
        love.graphics.printf(rank .. ". " .. entry.name .. " - Affection: " .. entry.affection .. " (" .. entry.totalPhotos .. " photos)", 0, y, 800, "center")
    end
end

function ScreenRenderer.drawEndGame()
    local gameData = GameDataManager.gameData
    love.graphics.setFont(AssetManager.getFont("title"))
    love.graphics.setColor(AssetManager.getColor("pink"))
    love.graphics.printf("Game Complete!", 0, 100, 800, "center")
    
    love.graphics.setFont(AssetManager.getFont("normal"))
    love.graphics.setColor(AssetManager.getColor("white"))
    -- Show outcome based on affection
    local chosenIndex = 1
    local highestAffection = -9999
    for i = 1, 5 do
        if gameData.waifus[i].affection > highestAffection then
            highestAffection = gameData.waifus[i].affection
            chosenIndex = i
        end
    end
    local resultText = (chosenIndex == gameData.winner) and "You guessed the winner!" or ("Your pick: " .. gameData.waifus[chosenIndex].name .. ", True winner: " .. gameData.waifus[gameData.winner].name)
    love.graphics.printf(resultText, 0, 150, 800, "center")
    
    -- Draw buttons
    if endGameButtons then
        for _, button in ipairs(endGameButtons) do
            button:draw(AssetManager.getColors(), AssetManager.getFonts())
        end
    end
end

function ScreenRenderer.drawCurrentScreen(currentState)
    local gameStates = GameStateManager.gameStates
    if currentState == gameStates.MAIN_MENU then
        ScreenRenderer.drawMainMenu()
    elseif currentState == gameStates.OPTIONS then
        ScreenRenderer.drawOptions()
    elseif currentState == gameStates.CHARACTER_SELECT then
        ScreenRenderer.drawCharacterSelect()
    elseif currentState == gameStates.MAIN_GAME then
        ScreenRenderer.drawMainGame()
    elseif currentState == gameStates.HINT_SCREEN then
        ScreenRenderer.drawHintScreen()
    elseif currentState == gameStates.PRE_ANNOUNCEMENT then
        ScreenRenderer.drawPreAnnouncement()
    elseif currentState == gameStates.WINNER_REVEAL then
        ScreenRenderer.drawWinnerReveal()
    elseif currentState == gameStates.RANKING then
        ScreenRenderer.drawRanking()
    elseif currentState == gameStates.END_GAME then
        ScreenRenderer.drawEndGame()
    end
end

return ScreenRenderer
