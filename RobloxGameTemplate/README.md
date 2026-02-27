# Roblox Game Template: Lobby, Map Voting, and Wave System

This folder structure is designed as a drop-in for Roblox Studio. It supports a lobby, map voting GUI, seamless map loading, wave-based gameplay, gotcha chests, shops, and more.

## Folder Structure

- **StarterGui/**
  - `MapVotePopup.rbxm`: Popup GUI for map voting
  - `LobbyGui.rbxm`: Lobby interface
- **StarterPlayer/**
  - (Player scripts, e.g., for custom controls or abilities)
- **ReplicatedStorage/**
  - **Remotes/**: RemoteEvents for client-server communication
    - `MapVoteEvent.lua`, `ShopEvent.lua`
  - **Modules/**: Shared modules (map loading, wave logic)
    - `MapLoader.lua`, `WaveManager.lua`
- **ServerScriptService/**
  - `GameManager.lua`: Handles voting, map loading, wave progression, gates
  - `ShopManager.lua`: Handles shop/gotcha logic
- **Workspace/**
  - (Lobby, doors, gates, countdown barriers, etc.)
- **Maps/**
  - (Individual map folders/models)
- **Assets/**
  - **Guns/**, **Abilities/**, **Enemies/**, **Units/**, **Chests/**, **Skins/**, **Accessories/**
- **Shop/**
  - (Shop UI, product definitions)

## Features
- Lobby with map voting popup
- Seamless map loading (no new server)
- Countdown barrier while map loads
- Wave-based progression with gates
- Boss area with two gates (entry and respawn)
- Gotcha chests for guns and abilities
- Shop for guns, skins, accessories (Robux/gems/coins)
- Special units as rare drops (coin generators)

## Usage
1. Copy this folder into your Roblox Studio project.
2. Place contents into the appropriate Roblox services (StarterGui, ReplicatedStorage, etc.).
3. Implement your maps, assets, and scripts as needed.

---
This template is a starting point for your described game. Add your own models, scripts, and UI as needed.