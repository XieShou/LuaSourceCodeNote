function test_class()

    local Cls1 = Class("Cls1")

    function Cls1:Init()
        print("Cls1:Init")
    end


    local Cls2 = Class("Cls2", Cls1)
    local Cls3 = Class("Cls3", Cls2)
    local Cls4 = Class("Cls4", Cls3)
    local Cls5 = Class("Cls5", Cls4)
    local Cls6 = Class("Cls6", Cls5)
    local Cls7 = Class("Cls7", Cls6)

    local inst = Cls7.New()


    test_time_clear()
    test_memory_clear()

    for i = 1, 1000000 do
        inst:Init()
    end

    test_time_mark()
    test_memory_mark()
    test_memory_gc()
end