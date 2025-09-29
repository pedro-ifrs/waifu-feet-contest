local InputHandler = {}

local GameStateManager = require("modules.GameStateManager")
local SettingsManager = require("modules.SettingsManager")
local GameLogic = require("modules.GameLogic")
local Button = require("classes.Button")

local mainMenuButtons = {}
local optionsButtons = {}
local endGameButtons = {}

function InputHandler.initializeButtons()
    -- Clear existing buttons
    mainMenuButtons = {}
    optionsButtons = {}
    endGameButtons = {}
    
    -- Main menu buttons
    table.insert(mainMenuButtons, Button.new(300, 200, 200, 50, "Start Game", function()
        GameStateManager.changeState(GameStateManager.gameStates.CHARACTER_SELECT)
    end))
    table.insert(mainMenuButtons, Button.new(300, 270, 200, 50, "Options", function()
        GameStateManager.changeState(GameStateManager.gameStates.OPTIONS)
    end))
    table.insert(mainMenuButtons, Button.new(300, 340, 200, 50, "Exit", function()
        love.event.quit()
    end))
    
    -- Options buttons
    table.insert(optionsButtons, Button.new(300, 500, 200, 50, "Back to Menu", function()
        GameStateManager.changeState(GameStateManager.gameStates.MAIN_MENU)
    end))
    
    -- End game buttons
    table.insert(endGameButtons, Button.new(200, 300, 200, 50, "Play Again", function()
        GameLogic.resetGame()
        GameStateManager.changeState(GameStateManager.gameStates.CHARACTER_SELECT)
    end))
    table.insert(endGameButtons, Button.new(400, 300, 200, 50, "Exit", function()
        love.event.quit()
    end))
end

function InputHandler.updateButtonHovers()
    local mx, my = love.mouse.getPosition()
    local currentState = GameStateManager.getCurrentState()

    if currentState == GameStateManager.gameStates.MAIN_MENU then
        for _, button in ipairs(mainMenuButtons) do
            button:update(mx, my)
        end
    elseif currentState == GameStateManager.gameStates.OPTIONS then
        for _, button in ipairs(optionsButtons) do
            button:update(mx, my)
        end
    elseif currentState == GameStateManager.gameStates.END_GAME then
        for _, button in ipairs(endGameButtons) do
            button:update(mx, my)
        end
    end
end

function InputHandler.handleMouseClick(x, y, button)
    if button == 1 then -- Left click
        local currentState = GameStateManager.getCurrentState()

        if currentState == GameStateManager.gameStates.MAIN_MENU then
            if #mainMenuButtons > 0 then
                for _, btn in ipairs(mainMenuButtons) do
                    btn:click(x, y)
                end
            else
                -- Fallback: if buttons aren\'t loaded, start game on any click
                GameStateManager.changeState(GameStateManager.gameStates.CHARACTER_SELECT)
            end
        elseif currentState == GameStateManager.gameStates.OPTIONS then
            -- Handle volume slider
            if x >= 250 and x <= 550 and y >= 180 and y <= 200 then
                SettingsManager.adjustVolume(x, 250, 550)
            end
            
            -- Handle back button
            for _, btn in ipairs(optionsButtons) do
                btn:click(x, y)
            end
        elseif currentState == GameStateManager.gameStates.MAIN_GAME then
            -- Check button clicks
            if x >= 200 and x <= 300 and y >= 400 and y <= 450 then
                GameLogic.handleYesClick()
            elseif x >= 500 and x <= 600 and y >= 400 and y <= 450 then
                GameLogic.handleNoClick()
            elseif x >= 350 and x <= 450 and y >= 400 and y <= 450 and SettingsManager.getSetting("hintsEnabled") then
                GameLogic.handleHintClick()
            end
        elseif currentState == GameStateManager.gameStates.END_GAME then
            for _, btn in ipairs(endGameButtons) do
                btn:click(x, y)
            end
        end
    end
end

function InputHandler.handleKeyPressed(key)
    local currentState = GameStateManager.getCurrentState()

    if key == "escape" then
        if currentState == GameStateManager.gameStates.OPTIONS then
            GameStateManager.changeState(GameStateManager.gameStates.MAIN_MENU)
        elseif currentState == GameStateManager.gameStates.HINT_SCREEN then
            GameStateManager.changeState(GameStateManager.gameStates.MAIN_GAME)
        else
            love.event.quit()
        end
    elseif key == "f" and currentState == GameStateManager.gameStates.OPTIONS then
        SettingsManager.toggleFullscreen()
    elseif key == "h" and currentState == GameStateManager.gameStates.OPTIONS then
        SettingsManager.toggleHints()
    end
end

function InputHandler.getMainMenuButtons()
    return mainMenuButtons
end

function InputHandler.getOptionsButtons()
    return optionsButtons
end

function InputHandler.getEndGameButtons()
    return endGameButtons
end

return InputHandler
