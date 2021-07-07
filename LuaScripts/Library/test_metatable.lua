--- 测试Lua元表的各项功能
--- ltm.h
--- typedef enum { TM_MODE,
---   TM_IDIV, TM_BAND, TM_BOR, TM_BXOR, TM_SHL,
--- TM_SHR,  TM_BNOT, , TM_CLOSE, TM_N
---} TMS;



--[[
do
    local st = {[1] = 2, [2] = 4, [3] = 8, [4] = 16}
--- TM_INDEX
--- TM_NEWINDEX
    local mtt = {
        __index = st,
        __newindex = st,
    }

    -- 通过函数做出了额外功能，赋值时给st赋值，取值时子表缓存值
    local mtf = {
        __index = function(t, k)
            t[k] = st[k]
            return t[k]
        end,
        __newindex = function(t, k, v)
            st[k] = v
        end,
    }
    local get_t = setmetatable({}, mtt)
    local get_f = setmetatable({}, mtf)
    print(get_t[1])
    print(get_f[2])
end]]


--[[
do
    local st1 = { x = 2, y = 2, z = 2}
    local st2 = { x = 5, y = 5, z = 5}

    local function prt(op, t)
        print(string.format("%s  x %s, y %s, z %s", op, t.x, t.y, t.z))
    end
    local mtt
    mtt = {
        --- TM_ADD, TM_SUB, TM_MUL, TM_DIV,
        __add = function(a, b)
            local result = { x = a.x + b.x, y = a.y + b.y, z = a.z + b.z}
            return setmetatable(result, mtt)
        end,
        __sub = function(a, b)
            local result = { x = a.x - b.x, y = a.y - b.y, z = a.z - b.z}
            return setmetatable(result, mtt)
        end,
        __mul = function(a, b)
            local result = { x = a.x * b.x, y = a.y * b.y, z = a.z * b.z}
            return setmetatable(result, mtt)
        end,
        __div = function(a, b)
            local result = { x = a.x / b.x, y = a.y / b.y, z = a.z / b.z}
            return setmetatable(result, mtt)
        end,

        --- TM_MOD, TM_POW, TM_UNM, TM_CALL,
        __mod = function(a, b)
            local result = { x = a.x % b.x, y = a.y % b.y, z = a.z % b.z}
            return setmetatable(result, mtt)
        end,
        __pow = function(a, b)
            local result = { x = a.x ^ b.x, y = a.y ^ b.y, z = a.z ^ b.z}
            return setmetatable(result, mtt)
        end,
        __unm = function(a)
            local result = { x = -a.x, y = -a.y, z = -a.z}
            return setmetatable(result, mtt)
        end,
        __call = function (self, ...)
            print(self)
        end,

        --- TM_EQ, TM_LT, TM_LE, TM_LEN, TM_CONCAT
        __eq = function(a, b)
            return a.x == b.x and a.y == b.y and a.z == b.z
        end,
        __lt = function(a, b) return a.x < b.x end,
        __le = function(a, b) return a.x <= b.x end,
        __len = function(a) return math.sqrt( a.x * a.x + a.y *a.y + a.z * a.z)  end,
        __concat = function(a, b)
            local result = { x = a.x + b.x, y = a.y + b.y, z = a.z + b.z}
            return setmetatable(result, mtt)
        end,
        __tostring = function(t) return string.format("x %s, y %s, z %s", t.x, t.y, t.z) end,
    }
    setmetatable(st1, mtt)
    setmetatable(st2, mtt)

    print("+", st1 + st2)
    print("-", st1 - st2)
    print("*", st1 * st2)
    print("/", st1 / st2)
    print("%", st1 % st2)
    print("^", st1 ^ st2)
    print("-", -st1)

    st1()

    print("==", tostring(st1 == st2))
    print("<", tostring(st1 < st2))
    print("<=", tostring(st1 <= st2))
    print("#", tostring(#st1))
    print("..", tostring(st1 .. st2))

end--]]

--[[
do
    local st = { id = 2 }
    local mtt = {
        --- TM_GC
        __gc = function(self)
            print("gc " .. tostring(self))
        end,
        __tostring = function(t) return t.id end,
    }
    local get_f = setmetatable({}, mtt)
    get_f.id = 1
    get_f = nil
end--]]

do
    local st_k = { name = "st_k" }
    local st_v = { name = "st_v" }

    local mtt = {
        --- 以下三种模式，代表table中的key和value对其他表的引用为弱引用。
        --- 当其弱引用表计算GC时，弱引用不会作为GC算法中"是否被其他表引用"的根据。

        --- 当使用该选项，get_t.data无法保持对st_v的引用
        --__mode = "v",

        --- 采用该选项，st_k置空时，由于没有地方存在其引用，st_k是真的被GC掉了。
        --- 如果其他地方还存在对st_k的引用，则也不会被GC掉，遍历也会显示出来，st_v即是如此
        --__mode = "k",

        --- 采用该选项即不会有上面的情况，否则分析起来挺复杂的
        __mode = "kv",
    }
    local get_t = setmetatable({}, mtt)
    get_t[st_k] = 1
    get_t[st_v] = 2
    get_t.data = st_v
    print("from key  " .. tostring(get_t[st_k]))
    print("from value  " .. tostring(get_t.data))
    st_k = nil
    st_v = nil
    collectgarbage()
    for k, v in pairs(get_t) do
        print("from key in memory " .. tostring(k.name) .. " " .. tostring(v))
    end
    print("from key  " .. tostring(get_t[st_k])) -- 不加tostring会报index nil value
    print("from value  " .. tostring(get_t.data))

end

