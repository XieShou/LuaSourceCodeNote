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

--- Classֻ��һ������̳й�ϵ��table����Ҫ����New����ʵ��
--- �����ֻ��һ��table���޷��������ຯ��
local Class = function(name, super)
    local cls = {}
    cls.__ctor = false
    cls.__dtor = false
    cls.__cls_name = name

    cls._get_cls_name = function()
        return cls.__cls_name
    end
    cls.__meta_tb = {
        __index = function(tb, key)
            -- �ӵ�ǰʵ���Ļ������ң��Ҳ����ʹӸ�������
            local ex = cls
            local v = ex[key] --���ڵ�ǰ�����ң��Ҳ�����ȥ������
            if v ~= nil then
                tb[key] = v
                return v
            end
            while ex.__super ~= nil do
                local value = ex.__super[key]--���д��__newindex��Ҫ��rawget
                if value then
                    tb[key] = value
                    return value
                else
                    ex = ex.__super
                end
            end
            return nil
        end,
        __mode = "kv", -- ���������ñ�����hotfix
    }
    cls.New = function(...)
        local obj = {}
        obj.__ctor = false
        obj.__dtor = false
        --ʵ������__super�ֶη����ӡtable
        setmetatable(obj, cls.__meta_tb)
        call_ctor(obj, cls, ...)

        return obj
    end

    cls.Destroy = function(self)
        call_dtor(self, cls)
    end

    cls.__super = super
    return cls
end

_G.Class = Class