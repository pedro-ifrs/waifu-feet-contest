local GameDataManager = {}

GameDataManager.gameData = {
    waifus = {
        {name = "Waifu1", eliminated = false, affection = 0, totalPhotos = 0},
        {name = "Waifu2", eliminated = false, affection = 0, totalPhotos = 0},
        {name = "Waifu3", eliminated = false, affection = 0, totalPhotos = 0},
        {name = "Waifu4", eliminated = false, affection = 0, totalPhotos = 0},
        {name = "Waifu5", eliminated = false, affection = 0, totalPhotos = 0}
    },
    winner = nil,
    currentPhoto = 1,
    totalPhotos = 25,
    photos = {},
    playerChoices = {}, -- Track player's Yes/No choices for each photo
    images = {}, -- Store loaded images
    sounds = {} -- Store loaded sounds
}

function GameDataManager.initializeGame()
    -- Reset game data
    for i = 1, 5 do
        GameDataManager.gameData.waifus[i].eliminated = false
        GameDataManager.gameData.waifus[i].affection = 0
        GameDataManager.gameData.waifus[i].totalPhotos = 0
    end
    
    -- Select random winner
    GameDataManager.gameData.winner = math.random(1, 5)
    
    -- Generate photo sequence: exactly 5 photos per waifu (5 waifus × 5 photos = 25 total)
    GameDataManager.gameData.photos = {}
    
    -- Create photo pool with exactly 5 photos for each waifu
    local photoPool = {}
    
    -- Add exactly 5 photos for each waifu
    for i = 1, 5 do
        for j = 1, 5 do
            table.insert(photoPool, i)
        end
    end
    
    -- Shuffle the photo pool to randomize the order
    for i = #photoPool, 2, -1 do
        local j = math.random(i)
        photoPool[i], photoPool[j] = photoPool[j], photoPool[i]
    end
    
    GameDataManager.gameData.photos = photoPool
    
    GameDataManager.gameData.currentPhoto = 1
    GameDataManager.gameData.playerChoices = {}
end

function GameDataManager.resetGameData()
    GameDataManager.initializeGame()
end

function GameDataManager.getCurrentWaifuIndex()
    return GameDataManager.gameData.photos[GameDataManager.gameData.currentPhoto]
end

function GameDataManager.advancePhoto()
    GameDataManager.gameData.currentPhoto = GameDataManager.gameData.currentPhoto + 1
end

function GameDataManager.isGameOver()
    return GameDataManager.gameData.currentPhoto > GameDataManager.gameData.totalPhotos
end

function GameDataManager.updateWaifuAffection(waifuIndex, amount)
    GameDataManager.gameData.waifus[waifuIndex].affection = GameDataManager.gameData.waifus[waifuIndex].affection + amount
end

function GameDataManager.markWaifuEliminated(waifuIndex)
    GameDataManager.gameData.waifus[waifuIndex].eliminated = true
end

function GameDataManager.incrementWaifuPhotoCount(waifuIndex)
    GameDataManager.gameData.waifus[waifuIndex].totalPhotos = GameDataManager.gameData.waifus[waifuIndex].totalPhotos + 1
end

function GameDataManager.recordPlayerChoice(photoIndex, choice)
    GameDataManager.gameData.playerChoices[photoIndex] = choice
end

return GameDataManager
