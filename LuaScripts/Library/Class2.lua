local function call_ctor(obj, cls, ...)
    if cls.__super then
        call_ctor(obj, cls.__super, ...)
    end
    if cls.__ctor then
        cls.__ctor(obj, ...)
    end
end

local function call_dtor(obj, cls)
    if cls.__dtor then
        cls.__dtor()
    end
    if cls.__super then
        call_dtor(obj, cls.__super)
    end
end

local Class = function(name, super)
    local cls = {}
    cls.__ctor = false
    cls.__dtor = false
    cls.__cls_name = name

    cls._get_cls_name = function()
        return cls.__cls_name
    end

    cls.New = function(...)
        local obj = {}
        obj.__ctor = false
        obj.__dtor = false

        setmetatable(obj,  {
            __index = cls,
            __mode = "kv", -- 设置弱引用表，方便hotfix
        })
        call_ctor(obj, cls, ...)

        return obj
    end

    cls.Destroy = function(self)
        call_dtor(self, cls)
    end

    if super then
        cls.__super = super
        setmetatable(cls, { __index = cls.__super })
    end
    return cls
end

_G.Class = Class