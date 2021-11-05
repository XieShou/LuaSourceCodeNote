local Cls1 = Class("Cls1")

function Cls1:Init()
    print("Cls1:Init")
end


local Cls2 = Class("Cls2", Cls1)
local Cls3 = Class("Cls3", Cls2)

local inst = Cls3.New()


inst:Init()