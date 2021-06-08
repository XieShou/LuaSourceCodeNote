# lstring

## *lstring.h*

1. 提前定义内存不足的错误消息，在内存耗尽后无法创建。
   
   ```c
   #define MEMERRMSG "not enough memory"
   ```

2. TString的大小：头的大小加上字符串本身的空间（包括最后的'\0'）
   
   ```c
   #define sizelstring(l)  (offsetof(TString, contents) + ((l) + 1) * sizeof(char))
   #define luaS_newliteral(L, s)    (luaS_newlstr(L, "" s, \(sizeof(s)/sizeof(char))-1))
   ```

3. 测试一个字符串是否为保留关键字
   
   ```c
   #define isreserved(s)    ((s)->tt == LUA_VSHRSTR && (s)->extra > 0)
   ```

4. 测试短字符串是否相等
   
   ```lua
   #define eqshrstr(a,b)	check_exp((a)->tt == LUA_VSHRSTR, (a) == (b))
   ```

## *lstring.c*

1. 判断长字符串是否相等
   
   ```c
   int luaS_eqlngstr (TString *a, TString *b) { }
   ```


