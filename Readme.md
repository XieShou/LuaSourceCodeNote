# Lua笔记

## 编译

需要生成*DLL、lua.exe、luac.exe*。

1. 创建一个C++空项目，取名例如`gen-5.4.3`。

2. 创建如下三个工程：
   
   - C++DLL工程：Dll
   
   - C++控制台工程：Lua
   
   - C++控制台工程：Luac

3. 取消预编译头!
   
   ![](C:\Users\XieShou\AppData\Roaming\marktext\images\2021-06-08-22-43-13-image.png)

4. 将源代码分别托给三个项目，按照如下规则**移除**对应文件：
   
   - C++DLL工程：移除`lua.c+luac.c`。
   
   - C++控制台工程Lua：移除`luac.c`。
   
   - C++控制台工程Luac：移除`lua.c`。

5. 编译，工程目录和结果如下：
   
   ![](C:\Users\XieShou\AppData\Roaming\marktext\images\2021-06-08-22-48-34-image.png)![](C:\Users\XieShou\AppData\Roaming\marktext\images\2021-06-08-22-48-25-image.png)




