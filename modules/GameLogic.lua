local GameLogic = {}

local GameDataManager = require("modules.GameDataManager")
local GameStateManager = require("modules.GameStateManager")
local EffectsManager = require("modules.EffectsManager")
local AssetManager = require("modules.AssetManager")
local SettingsManager = require("modules.SettingsManager")

function GameLogic.handleYesClick()
    local currentWaifuIndex = GameDataManager.getCurrentWaifuIndex()
    
    GameDataManager.recordPlayerChoice(GameDataManager.gameData.currentPhoto, "Yes")
    EffectsManager.createHeartsEffect()
    GameDataManager.updateWaifuAffection(currentWaifuIndex, 1)
    AssetManager.playSound("yesBaby")
    GameDataManager.incrementWaifuPhotoCount(currentWaifuIndex)
    
    GameLogic.nextPhoto()
end

function GameLogic.handleNoClick()
    local currentWaifuIndex = GameDataManager.getCurrentWaifuIndex()
    
    GameDataManager.recordPlayerChoice(GameDataManager.gameData.currentPhoto, "No")
    EffectsManager.createRedFlash()
    GameDataManager.updateWaifuAffection(currentWaifuIndex, -1)
    
    if GameDataManager.gameData.waifus[currentWaifuIndex].affection <= -3 then
        GameDataManager.markWaifuEliminated(currentWaifuIndex)
    end
    AssetManager.playSound("ohNoBaby")
    GameDataManager.incrementWaifuPhotoCount(currentWaifuIndex)
    
    GameLogic.nextPhoto()
end

function GameLogic.handleHintClick()
    EffectsManager.createBlueGlow()
    AssetManager.playSound("plim")
    GameStateManager.changeState(GameStateManager.gameStates.HINT_SCREEN)
end

function GameLogic.nextPhoto()
    GameDataManager.advancePhoto()
    if GameDataManager.isGameOver() then
        GameDataManager.calculateWinner()
        GameStateManager.changeState(GameStateManager.gameStates.PRE_ANNOUNCEMENT)
    end
end

function GameLogic.resetGame()
    GameDataManager.resetGameData()
    -- Reset effects
    EffectsManager.redFlash = 0
    EffectsManager.blueGlow = 0
    EffectsManager.hearts = {}
end

return GameLogic
