# Oaklands - Sunken Script

A comprehensive Lua script for the Oaklands game with advanced automation, ESP, and customization features.

**Version:** v1.2.1

## 📋 Table of Contents
- [Features](#features)
- [Installation](#installation)
- [Usage](#usage)
- [UI Guide](#ui-guide)
- [Commands](#commands)

---

## 🎯 Features

### 🌳 Tree Automation
- **Tree Aura** - Automatically chops nearby trees in a continuous loop
- **Log Aura** - Automatically breaks fallen logs in a radius
- **Smart Tree Detection** - Automatically finds closest tree in the Island region
- **Lowest Part Detection** - Intelligently targets the lowest part of trees for optimal chopping

### ⛏️ Mining Automation
- **Ore Aura** - Automatically mines nearby ore deposits in a continuous loop
- **Ore Type Support** - Works with all ore types:
  - Magnetite (Bright violet)
  - Rosa Quartz (Carnation pink)
  - Mythril (Med. bluish green)
  - Gold (Br. yellowish orange)
  - Iron (Dark grey)
  - Pyrite (Flame yellowish orange)
  - Quartz (Institutional white)
  - Tin (Light stone grey)
  - Copper (Flame reddish orange)
- **Smart Ore Detection** - Finds closest ore deposits automatically

### 📍 Teleportation System
**Quick Teleport Buttons:**
- Oak Depot (selling location)
- Lighthouse
- Dock
- Island
- Crossway
- Junkyard
- Mountains
- Abandoned Shelter
- Beach Hut
- Lake
- Player's Plot
- Nearest Owned Log
- Nearest Owned Ore

**Advanced Teleport:**
- Ctrl + Click to Teleport - Hold Ctrl and click to teleport to mouse position
- Intelligent height adjustment for seated players

### 👤 Player Features
- **Sprint Toggle** - Hold shift to sprint
- **Walkspeed Slider** - Adjust walkspeed from 16 to 24 units
- **Real-time Updates** - Walkspeed changes applied every 0.1 seconds

### 🚗 Vehicle Customization
- **Clean Car** - Remove corrosion from vehicle parts
- **Speed Modifier** - Set vehicle max speed (50-250 units)
- **Color Customization** - Change vehicle color (excludes wheels and headlights)
- **License Plate Text** - Customize license plate display text
- **Vehicle Detection** - Automatically finds owned vehicle

### ✨ Lighting & Environment
- **Full Bright Mode** - Set lighting to always noon (12:00)
- **Toggleable** - Enable/disable with one click
- **Smooth Implementation** - Uses hooked lighting system

### 👁️ ESP System
**Ore ESP Features:**
- Visual boxes around ore deposits
- Player names and positions
- Toggleable ore types:
  - Individual toggle for each ore type
  - Master toggle for all ESP
  - Real-time ESP updates as ores spawn/despawn
- **Kiriot ESP Integration** - Uses advanced ESP library
- Rainbow color accent (continuously cycling)

**ESP Display Options:**
- Boxes - Draw bounding boxes around targets
- Names - Display names above objects
- Players - Show other player locations

### 🔍 Item Search & Tracking
- **Real-time Item Search** - Search for any item in the world by name
- **Smart Highlighting** - Golden highlight around found items for easy spotting
- **Distance Counter** - Live distance display that updates as you move
- **Auto-Sort by Distance** - Results automatically sorted by closest first (10 max)
- **Item Spawning Detection** - Chat notifications when items spawn/are found
- **Teleport to Results** - Click any result to instantly teleport
- **Clear Highlights** - Remove highlighting with one button
- **Perfect for Golden Apples** - Find specific items like golden apples quickly
- **Works with Any Item** - Search trees, rocks, apples, or any world object

### 🎨 Customization
**Themes:**
- Multiple built-in themes
- Custom theme creation
- Color picker for theme elements:
  - Accent color
  - Window background/border
  - Tab styling
  - Section styling
  - Text colors
  - UI element backgrounds

**Configuration System:**
- Save/Load configurations
- Delete saved configs
- Quick configuration switching
- Config management interface

### 🛡️ Anti-Cheat Bypass
- **Logging Bypass** - Disables game message logger
- **Error Bypass** - Disables script error detection
- **Hooked Systems** - Custom hooks for:
  - Humanoid properties (WalkSpeed, JumpPower)
  - Lighting properties (ClockTime)
- **Inventory Caching** - Efficient server communication

### 🔒 Safety & Reliability
- **Error Handling** - 13+ error messages for debugging
- **Nil-Safety Checks** - 25+ validation checks throughout
- **Non-Blocking Loops** - Uses task.spawn for auras (doesn't freeze UI)
- **Character Validation** - Verifies character exists before operations
- **Smart Retries** - Functions gracefully handle missing objects
- **Safe Inventory Lookup** - Caches inventory with validation

### 📊 Information Display
- Game version detection
- Script version display
- Changelog and updates
- Status indicators

---

## 🎮 UI Guide

### Main Tabs

**Home Tab**
- Changelog and script information
- Version status indicators

**Main Tab**
- **Trees Section** - Tree/Log aura controls
- **Ores Section** - Ore aura controls
- **Misc Section** - Full bright and sprint toggles
- **Teleports Section** - Quick location buttons
- **Player Section** - Walkspeed adjustment
- **Vehicle Section** - Car customization options

**ESP Tab**
- **ESP Section** - ESP toggle and display options
- **Ore ESP Options** - Individual ore type toggles

**Configuration Tab**
- **Theme Section** - Theme selection and customization
- **Custom Theme Section** - Color picker for theme elements
- **Configs Section** - Save/load/delete configurations

**Search Tab**
- **Item Search Section** - Search box for any world item
- **Real-time Distance Counter** - Live distance display
- **Results Section** - List of found items with teleport buttons
- **Clear Highlights Button** - Remove all item highlights
- **Teleport to Closest Button** - Quick teleport to nearest result

**Search Tab**
- **Item Search Section** - Search box for any world item
- **Real-time Distance Counter** - Live distance display
- **Results Section** - List of found items with teleport buttons
- **Clear Highlights Button** - Remove all item highlights
- **Teleport to Closest Button** - Quick teleport to nearest result

**Information Tab**
- Game version
- Script version

---

## 💾 Installation

1. Copy the script file to your executor
2. Load the script in your Roblox executor
3. Wait for initialization (shows anti-cheat bypass status)
4. Confirm script version if outdated warning appears

---

## 🚀 Usage

### Basic Workflow
1. **Start Script** - Execute the script
2. **Customize** - Adjust settings in Configuration tab
3. **Enable Features** - Toggle desired auras/features
4. **Monitor** - Use ESP to locate resources
5. **Teleport** - Navigate quickly with teleport buttons

### Aura Usage
- **Toggle On** - Click the toggle to enable
- **Toggle Off** - Click again to disable
- Loops run automatically in background
- No UI blocking while running

### Teleportation
- Click location buttons to teleport instantly
- Use Ctrl+Click for custom positions
- Automatic height adjustment for safety

### Vehicle Customization
1. Enter your vehicle
2. Adjust settings in Vehicle section
3. Click "Assign" buttons to apply changes

---

## ⚙️ Commands & Keybinds

| Action | Method |
|--------|--------|
| Toggle Auras | Click toggle buttons |
| Teleport | Click location button |
| Custom Teleport | Ctrl + Click anywhere |
| Sprint | Hold Shift |
| Adjust Speed | Drag slider |
| Customize Colors | Use color picker |
| Save Config | Enter name and click Save |
| Load Config | Select from dropdown and click Load |

---

## 🔧 Advanced Features

### Inventory Caching
- Automatically finds and caches inventory module
- Reduces server communication overhead
- Improves performance during active auras

### Smart Detection
- Automatically detects:
  - Player's plot location
  - Owned logs and ore
  - Closest resources
  - Vehicle position and ownership

### Error Logging
- Script creates error logs in executor directory
- Useful for debugging and troubleshooting
- Auto-saves with timestamp

---

## ⚠️ Important Notes

1. **Anti-Cheat Bypass** - Initializes on script startup
2. **Plot Required** - Script waits for player to have a plot
3. **Character Validation** - Always verifies character before operations
4. **Server Communication** - Uses InformServer for legitimate-looking actions
5. **Configuration Saving** - Configs saved locally in executor

---

## 🎨 Customization Options

### Walkspeed
- Minimum: 16 units/s
- Maximum: 24 units/s
- Default: 16 units/s

### Vehicle Speed
- Minimum: 50 units/s
- Maximum: 250 units/s
- Default: 50 units/s

### Aura Intervals
- Tree/Log/Ore Auras: 0.05s loop
- Walkspeed Updates: 0.1s loop
- Break Action: 0.5s wait

---

## 📝 Version History

**v1.2.1 (Current)**
- Fixed blocking aura loops with task.spawn
- Consolidated duplicate utility functions
- Added comprehensive error handling
- Improved callback documentation
- Added inventory caching efficiency
- Consolidated Break functions
- Enhanced nil-safety checks

---

## 🤝 Support

For issues or questions:
1. Check error logs in executor directory
2. Verify script version is current
3. Ensure you have a plot in-game
4. Try reloading the script

---

## 📄 License

This script is provided as-is for educational purposes.