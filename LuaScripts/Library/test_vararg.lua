----------------------------------------
--- Lua5.1中可变参数可能导致GC的性能消耗，从网上找的案例测试
--- https://www.cnblogs.com/simonw/archive/2010/01/28/lua-function-var-params.html
--[[
第一步要把GC关掉, 以免中途引发垃圾回收影响我们对内存大小的观察. test方法中的每一行都是一种情况, 运行时请将其他行注释掉, 保持一行在执行, 每行后面的注释result momery则是在当前用法下内存大小的结果.

从上面例子的结果中, 我们看到了在对"..."应用不同的使用方式时内存变化的情况
同样的东西, 内存占用却是从20多到800多的巨大差异, 在偶尔几次的调用中这个差异是微不足道的, 一旦被大量重复调用, 缺陷立刻被放大化
有的方式会频繁的将"..."的内容创建为一个临时表, 在函数结束后stack上的值类型参数内容将被清空, 创建的临时表却留在了heap中,
大量临时表的出现将可能引起频繁的垃圾回收导致影响性能, 这就是应该注意的地方. 同时也看到了一些有趣的现象

    调用语句E和F, 这里没有使用"..."中的参数, 它却创建了临时表.
    调用语句B, 随便应用下"...", 哪怕不真正的用它, 也不会创建临时表.
    调用语句H, 一旦应用了"...", arg的临时表变量就不会被创建. 至此看出些端倪了吧, 应证了上两个现象的结果.
    调用语句I, 可以看出arg临时表的内存消耗竟然快是自建表的近2倍.

知道这些规律了, 对写程序应该是很有帮助的, 可能你还在发愁为何gc会被频繁调用, 问题就在这里了.
]]
local unpack = table.unpack
collectgarbage("stop")
print("---------------------------------------------------")
test_memory_clear()
--[[
local function test(...)
    --return 1 + select(1, ...) --A result memory:22.2587890625
    --select(1,...);return 1 --B result memory:22.2587890625
    --return 1, ... --C result memory:22.0947265625
    --local arg = {...};
    --return 1 + arg[1] --D result memory:803.3623046875
    --return 1 --E result memory:803.3544921875
    --return 1 + 1 --F result memory:803.3544921875
    --return 1, unpack(arg) --G result memory:803.5185546875
    --return 1, arg[1], ... --H error attempt to index local 'arg' (a nil value)
    --return 1 + #{...} --I result memory:490.9072265625
    --select(1,...);return 1,{1} --J result memory:491.0712890625
end
test_memory_mark()
for i = 1, 100000 do
    test(i)
end
test_memory_mark()]]

local function test1(dd,kk, rr,aa)
    dd = dd
    kk = kk
    rr = rr
    aa = aa
end
test_memory_clear()

local function test2(...)
    test1(...)
end

for i = 1, 10000 do
    test2(i, i, i, i)
end
test_memory_mark()
local function test3(dd,kk, rr,aa)
    test1(dd,kk, rr,aa)
end
for i = 1, 10000 do
    test3(i, i, i, i)
end
test_memory_mark()
print("---------------------------------------------------")