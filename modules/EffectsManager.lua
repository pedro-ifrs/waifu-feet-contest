local EffectsManager = {}

local effects = {
    hearts = {},
    redFlash = 0,
    blueGlow = 0
}

function EffectsManager.updateEffects(dt)
    -- Update visual effects
    if effects.redFlash > 0 then
        effects.redFlash = effects.redFlash - dt * 3
    end
    
    if effects.blueGlow > 0 then
        effects.blueGlow = effects.blueGlow - dt * 2
    end
    
    -- Update hearts effect
    for i = #effects.hearts, 1, -1 do
        local heart = effects.hearts[i]
        heart.y = heart.y - heart.speed * dt
        heart.alpha = heart.alpha - dt
        if heart.alpha <= 0 then
            table.remove(effects.hearts, i)
        end
    end
end

function EffectsManager.drawEffects(colors)
    -- Draw hearts
    love.graphics.setColor(colors.pink)
    for _, heart in ipairs(effects.hearts) do
        love.graphics.setColor(1, 0.7, 0.8, heart.alpha)
        love.graphics.circle("fill", heart.x, heart.y, 5)
    end
    
    -- Draw red flash
    if effects.redFlash > 0 then
        love.graphics.setColor(1, 0, 0, effects.redFlash)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
    end
    
    -- Draw blue glow
    if effects.blueGlow > 0 then
        love.graphics.setColor(0, 0.5, 1, effects.blueGlow)
        love.graphics.rectangle("fill", 0, 0, 800, 600)
    end
end

function EffectsManager.createHeartsEffect()
    for i = 1, 10 do
        table.insert(effects.hearts, {
            x = math.random(100, 700),
            y = 500,
            speed = math.random(50, 100),
            alpha = 1
        })
    end
end

function EffectsManager.createRedFlash()
    effects.redFlash = 1
end

function EffectsManager.createBlueGlow()
    effects.blueGlow = 1
end

return EffectsManager
