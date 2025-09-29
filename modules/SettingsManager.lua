local SettingsManager = {}

local settings = {
    volume = 0.7,
    fullscreen = false,
    hintsEnabled = true
}

function SettingsManager.getSetting(key)
    return settings[key]
end

function SettingsManager.setSetting(key, value)
    settings[key] = value
end

function SettingsManager.toggleFullscreen()
    settings.fullscreen = not settings.fullscreen
    love.window.setFullscreen(settings.fullscreen)
end

function SettingsManager.toggleHints()
    settings.hintsEnabled = not settings.hintsEnabled
end

function SettingsManager.adjustVolume(x, minX, maxX)
    settings.volume = (x - minX) / (maxX - minX)
    if settings.volume < 0 then settings.volume = 0 end
    if settings.volume > 1 then settings.volume = 1 end
end

return SettingsManager
