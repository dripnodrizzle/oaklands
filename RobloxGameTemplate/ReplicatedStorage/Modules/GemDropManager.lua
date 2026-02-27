-- Handles gem drops on enemy death and gem pickup logic

local GemDropManager = {}

-- Call this when an enemy dies
function GemDropManager.OnEnemyDeath(enemy, killer)
    -- Award 2-3 gems to killer
    local gems = math.random(2, 3)
    -- (Award logic here)
    -- Randomly drop a gem in the world for anyone to pick up
    if math.random() < 0.5 then -- 50% chance, adjust as needed
        -- (Spawn gem pickup in world)
    end
end

return GemDropManager
