# Solo Leveling Game Template

This folder structure is designed as a drop-in for Roblox Studio to create a solo leveling RPG with:
- Guild quests (rank/level based)
- Monster and mana crystals (tiered drops)
- Dungeon and party system
- Contribution-based boss/dungeon rewards
- Aura system with debuffs and masking
- Gotcha-based hunter license and fighting style
- Shop for weapons/armor
- Future expansion placeholders

## Folder Structure
- **StarterGui/**
  - `GuildQuestBoard.rbxm`: Quest selection GUI
  - `QuestProgress.rbxm`: Quest progress tracker
  - `ContributionGraph.rbxm`: End-of-boss/dungeon contribution graph
  - `AuraToggle.rbxm`: Aura visibility/masking toggle
- **StarterPlayer/**
  - (Player scripts, e.g., for aura visuals, fighting style, etc.)
- **ReplicatedStorage/**
  - **Remotes/**: RemoteEvents for client-server communication
    - `QuestEvent.lua`, `DungeonEvent.lua`, `DropEvent.lua`, `AuraEvent.lua`
  - **Modules/**: Shared modules for quest, dungeon, drop, and aura logic
    - `QuestLogic.lua`, `DungeonLogic.lua`, `DropLogic.lua`, `AuraLogic.lua`
- **ServerScriptService/**
  - `QuestManager.lua`: Handles quest assignment, progress, and turn-in
  - `DungeonManager.lua`: Handles dungeon access, party logic, and runs
  - `DropManager.lua`: Handles monster/boss drops, crystals, money, rare items
  - `AuraManager.lua`: Handles aura visibility, debuff logic, and masking
- **Workspace/**
  - (Guild, quest board, dungeons, monsters, mana nodes, etc.)
- **Maps/**
  - (Dungeon and field map models)
- **Assets/**
  - **Monsters/**, **Crystals/**, **Weapons/**, **Armor/**, **ManaNodes/**, **Auras/**
- **Shop/**
  - (Shop UI, product definitions)

## Features
- Quests are required for drops, exp, and guild rep
- Monster and mana crystals drop by rank/tier
- Bosses drop rare weapons/armor (contribution-based)
- Gotcha for hunter license/fighting style (rank odds)
- Aura system with debuffs and masking
- Dungeon/party system with contribution graph
- Placeholders for future features (special action bar, wipes, etc.)

## Usage
1. Copy this folder into your Roblox Studio project.
2. Place contents into the appropriate Roblox services (StarterGui, ReplicatedStorage, etc.).
3. Implement your maps, assets, and scripts as needed.

---
This template is a starting point for your described solo leveling game. Expand with your own models, scripts, and UI as needed.