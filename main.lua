local GameStateManager = require("modules.GameStateManager")
local AssetManager = require("modules.AssetManager")
local GameDataManager = require("modules.GameDataManager")
local InputHandler = require("modules.InputHandler")
local ScreenRenderer = require("modules.ScreenRenderer")
local EffectsManager = require("modules.EffectsManager")

function love.load()
    math.randomseed(os.time())
    love.window.setTitle("Waifu Feet Contest")
    love.window.setMode(800, 600, {resizable = false})

    AssetManager.loadFonts()
    AssetManager.loadImages()
    AssetManager.loadSounds()
    GameDataManager.initializeGame()
    InputHandler.initializeButtons() -- Inicializa os botões
    
    -- Passa as referências dos botões para o ScreenRenderer
    ScreenRenderer.setButtons(
        InputHandler.getMainMenuButtons(),
        InputHandler.getOptionsButtons(),
        InputHandler.getEndGameButtons()
    )

    GameStateManager.changeState(GameStateManager.gameStates.MAIN_MENU)
end

function love.update(dt)
    EffectsManager.updateEffects(dt)
    InputHandler.updateButtonHovers()
    GameStateManager.updateState(dt)
end

function love.draw()
    love.graphics.setColor(AssetManager.getColor("white"))
    ScreenRenderer.drawCurrentScreen(GameStateManager.getCurrentState())
    EffectsManager.drawEffects(AssetManager.getColors())
end

function love.mousepressed(x, y, button)
    InputHandler.handleMouseClick(x, y, button)
end

function love.keypressed(key)
    InputHandler.handleKeyPressed(key)
end
