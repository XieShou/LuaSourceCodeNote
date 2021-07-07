--- ����LuaԪ��ĸ����
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

    -- ͨ�����������˶��⹦�ܣ���ֵʱ��st��ֵ��ȡֵʱ�ӱ���ֵ
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
        --- ��������ģʽ������table�е�key��value�������������Ϊ�����á�
        --- ���������ñ����GCʱ�������ò�����ΪGC�㷨��"�Ƿ�����������"�ĸ��ݡ�

        --- ��ʹ�ø�ѡ�get_t.data�޷����ֶ�st_v������
        --__mode = "v",

        --- ���ø�ѡ�st_k�ÿ�ʱ������û�еط����������ã�st_k����ı�GC���ˡ�
        --- ��������ط������ڶ�st_k�����ã���Ҳ���ᱻGC��������Ҳ����ʾ������st_v�������
        --__mode = "k",

        --- ���ø�ѡ����������������������������ͦ���ӵ�
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
    print("from key  " .. tostring(get_t[st_k])) -- ����tostring�ᱨindex nil value
    print("from value  " .. tostring(get_t.data))

end

