
local memory = 0

function test_memory_clear()
    collectgarbage("collect")
    memory = collectgarbage("count")
end

function test_memory_mark()
    local new_memory = collectgarbage("count")
    print("memory add:", tostring(new_memory - memory))
    memory = new_memory
end

function test_memory_gc()
    collectgarbage("collect")
    collectgarbage("collect")
    local new_memory = collectgarbage("count")
    print("gc result:", tostring(new_memory - memory))
    memory = new_memory
end

local time = 0
function test_time_clear()
    time = os.clock();
end

function test_time_mark()
    local new_time = os.clock();
    print("cost time:", new_time - time)
    time = new_time
end

collectgarbage("collect")
collectgarbage("stop")

--require("Library/test_metatable")
--require("Library/test_vararg")
require("Library/Class")
require("Library/test_class")
--require("Library/Class2")
test_class()
--print("-----------------")
--require("Library/Class")
--test_class()
--require("Library/test_raw")
--require("Library/hotfix/test_hotfix")