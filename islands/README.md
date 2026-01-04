# Islands Exploit Scripts

A comprehensive collection of exploit scripts for the Roblox game "Islands" (Skyblock).

## 📁 Scripts Overview

### Core Systems
- **islands-core-utils.lua** - Core utilities salvaged from decompiled Islands code
  - CoreGui manipulation (disable backpack, etc.)
  - Reset button control
  - Environment detection (Studio/Production)
  - Module scanner and framework detection

### Async & Performance
- **islands-async-exploiter.lua** - Hook into Islands' promise/async system
  - Intercept all Promise operations
  - Hook module imports
  - Remove wait() delays
  - Force instant promise resolution

### Interaction & Gameplay
- **islands-interact-exploiter.lua** - Auto-interact and range bypass
  - Auto-interact with everything
  - Spam F key interactions
  - Range bypass for interactions
  - Interact anywhere without proximity

- **islands-chest-exploiter.lua** - Complete chest automation
  - Auto-open chests within radius
  - Spam open/close chests
  - Teleport to chests
  - Monitor chest history

### Communication
- **islands-chat-exploiter.lua** - Chat and invite manipulation
  - Auto-accept/decline invites
  - Invite spammer
  - Chat logger
  - Bypass notification settings
  - Player list interceptor

### Debugging & Analysis
- **islands-error-suppressor.lua** - Clean up console and reveal hidden remotes
  - Suppress Roact.Children warnings
  - Suppress memory tracking errors
  - Intercept promise rejections
  - Reveal obfuscated RemoteEvents
  - Log timed-out remotes

- **islands-remote-spy.lua** - Intercept and decode all remote traffic
  - Hook all RemoteEvents (send & receive)
  - Decode obfuscated remote names
  - Log all arguments in real-time
  - Find suspicious/obfuscated remotes

- **islands-main-hook.lua** - Hook core game initialization
  - Intercept logger system
  - Monitor Flamework setup
  - Hook GameCoreClient
  - Track tool initialization
  - Monitor ClientReady signal

### Item Systems
- **islands-item-duper.lua** - Item duplication exploits
  - Race condition duplication
  - Request spam duplication
  - Storage transfer exploits
  - Multi-slot duplication
  - Drop/pickup exploits

## 🚀 Quick Start

### Basic Usage
```lua
-- Load a script
loadstring(game:HttpGet("your-url/islands-core-utils.lua"))()

-- Or use require if you have it as a module
local CoreUtils = require(script.islands["islands-core-utils"])
```

### Common Workflows

#### Full Monitoring Setup
```lua
-- Load all monitoring scripts
loadstring(game:HttpGet("url/islands-error-suppressor.lua"))()
loadstring(game:HttpGet("url/islands-remote-spy.lua"))()
loadstring(game:HttpGet("url/islands-main-hook.lua"))()
```

#### Chest Farming
```lua
local ChestExploit = loadstring(game:HttpGet("url/islands-chest-exploiter.lua"))()
ChestExploit.ChestFinder.findAllChests()
ChestExploit.AutoChestOpener.enable(15) -- Auto-open within 15m
```

#### Auto-Interact Everything
```lua
local InteractExploit = loadstring(game:HttpGet("url/islands-interact-exploiter.lua"))()
InteractExploit.AutoInteract.enable()
```

#### Item Duplication
```lua
local ItemDuper = loadstring(game:HttpGet("url/islands-item-duper.lua"))()
ItemDuper.RaceConditionDuper.enable()
-- Place item in specific slot and let it work
```

## 🔍 Key Discoveries

### Architecture
- Islands uses **TypeScript** (compiled to Lua via roblox-ts)
- **Flamework** for dependency injection
- **Rodux** for state management (Redux for Roblox)
- **Roact** for UI components
- **RuntimeLib** for module imports and async operations

### Network Structure
- Uses `NetworkService.sendClientRequest()` with `ClientRequestId`
- Heavily obfuscated RemoteEvent names
- 60-second timeouts on remote calls
- LegacyRequests for older network code

### Client Scripts
Located in `Players.LocalPlayer`:
- `main` - Core game initialization
- `interact-mouse` - Interaction system
- `chest` - Chest opening logic
- `client-chat-service` - Chat and invites

### Important Paths
```
ReplicatedStorage/
├── rbxts_include/
│   ├── RuntimeLib
│   ├── Promise
│   └── node_modules/@rbxts/
├── TS/
│   ├── remotes/
│   ├── network/
│   ├── util/
│   ├── store/rodux
│   └── games/
└── Modules/
```

## ⚠️ Important Notes

### Anti-Cheat
- Islands has server-side validation
- Many exploits only work client-side
- Item duplication may be patched
- Use at your own risk

### Best Practices
1. Start with monitoring scripts first
2. Test on alt accounts
3. Don't spam too aggressively
4. Some features may not work after updates

## 🛠️ Development

### Adding New Scripts
1. Decompile relevant Islands scripts
2. Identify key functions and remotes
3. Create hook/intercept script
4. Test thoroughly
5. Document usage

### Debugging
Use the error suppressor and remote spy together:
```lua
loadstring(game:HttpGet("url/islands-error-suppressor.lua"))()
loadstring(game:HttpGet("url/islands-remote-spy.lua"))()
-- Now you'll see clean output of all game activity
```

## 📝 Credits

Scripts created by analyzing and reverse-engineering Islands game code.
Decompiled using Konstant V2.1.

## ⚖️ Disclaimer

These scripts are for educational purposes only. Using exploits may result in account bans.
Use responsibly and at your own risk.
