local GameStateManager = {}

GameStateManager.gameStates = {
    MAIN_MENU = "main_menu",
    OPTIONS = "options", 
    CHARACTER_SELECT = "character_select",
    MAIN_GAME = "main_game",
    HINT_SCREEN = "hint_screen",
    PRE_ANNOUNCEMENT = "pre_announcement",
    WINNER_REVEAL = "winner_reveal",
    RANKING = "ranking",
    END_GAME = "end_game"
}

local currentState = GameStateManager.gameStates.MAIN_MENU
local stateTimers = {} -- Para gerenciar tempos de transição

function GameStateManager.changeState(newState)
    currentState = newState
    -- Resetar timers ou iniciar novos, se necessário
    if newState == GameStateManager.gameStates.CHARACTER_SELECT then
        stateTimers.characterSelect = love.timer.getTime()
    elseif newState == GameStateManager.gameStates.PRE_ANNOUNCEMENT then
        stateTimers.preAnnouncement = love.timer.getTime()
    elseif newState == GameStateManager.gameStates.WINNER_REVEAL then
        stateTimers.winnerReveal = love.timer.getTime()
    elseif newState == GameStateManager.gameStates.RANKING then
        stateTimers.ranking = love.timer.getTime()
    end
end

function GameStateManager.getCurrentState()
    return currentState
end

function GameStateManager.updateState(dt)
    -- Lógica de transição automática de estados
    if currentState == GameStateManager.gameStates.CHARACTER_SELECT then
        if love.timer.getTime() - stateTimers.characterSelect > 3 then
            GameStateManager.changeState(GameStateManager.gameStates.MAIN_GAME)
        end
    elseif currentState == GameStateManager.gameStates.PRE_ANNOUNCEMENT then
        if love.timer.getTime() - stateTimers.preAnnouncement > 2 then
            GameStateManager.changeState(GameStateManager.gameStates.WINNER_REVEAL)
        end
    elseif currentState == GameStateManager.gameStates.WINNER_REVEAL then
        if love.timer.getTime() - stateTimers.winnerReveal > 3 then
            GameStateManager.changeState(GameStateManager.gameStates.RANKING)
        end
    elseif currentState == GameStateManager.gameStates.RANKING then
        if love.timer.getTime() - stateTimers.ranking > 4 then
            GameStateManager.changeState(GameStateManager.gameStates.END_GAME)
        end
    end
end

return GameStateManager
