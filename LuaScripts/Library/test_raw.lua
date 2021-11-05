local source = {
    name = "123"
}

local get = {
}
setmetatable(get, {
    __index = function(tb, key)
        --return source[key]
        return rawget(source, key)
    end,
    --__index = source
})
test_time_clear()
for i = 1, 1000000 do
    local i = get.name
end

test_time_mark()