# getgenv Usage Guide for Roblox Executors

## What is getgenv?
getgenv is a function provided by many Roblox executors that returns the global environment table. You can use it to:
- Store global variables accessible across scripts
- Share data between different scripts
- Override functions or variables globally
- Set up persistent settings or state

## Common Uses

### 1. Storing Global Variables
```lua
getgenv().myVar = 123
print(getgenv().myVar) -- 123
```

### 2. Sharing Data Between Scripts
```lua
-- Script 1
getgenv().sharedData = {foo = "bar"}

-- Script 2
print(getgenv().sharedData.foo) -- "bar"
```

### 3. Overriding Functions
```lua
getgenv().print = function(...)
    -- Custom print function
end
```

### 4. Persistent Settings
```lua
getgenv().settings = {
    autoFarm = true,
    speed = 10
}
```

### 5. Accessing/Modifying Global Environment
```lua
local env = getgenv()
env.myGlobal = "Hello"
print(env.myGlobal)
```

## Tips
- getgenv variables are accessible from any script run in the same executor session.
- Use unique names to avoid conflicts with other scripts.
- You can store tables, functions, numbers, strings, etc.
- Useful for script toggles, settings, and communication.

## Example: Toggle Script
```lua
getgenv().toggle = true
if getgenv().toggle then
    print("Script is enabled!")
end
```

## Example: Communicate Between Scripts
```lua
-- Script 1
getgenv().message = "Hello from Script 1!"

-- Script 2
print(getgenv().message)
```

## Limitations
- getgenv is executor-specific; not available in Roblox Studio or official scripts.
- Not all executors support getgenv.
- Data is lost when the game or executor is closed.

## Summary
getgenv is a powerful tool for global variables, settings, and script communication in Roblox executors. Use it to enhance your scripts and share data easily.
