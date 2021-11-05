print("start hotfix")
local HotfixClass1 = require("Library/hotfix/HotfixClass1")
print(tostring(HotfixClass1.Init))
HotfixClass1.Init = function()
    print("Cls1:Init  Hotfix")
end
print(tostring(HotfixClass1.Init))