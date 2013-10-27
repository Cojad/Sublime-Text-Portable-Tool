@echo OFF
title Sublime Text 2 可攜版工具包
echo.
echo.               Sublime Text 2 便?版工具包 ?  明 @LOO2K
echo -----------------------------------------------------------------------
echo   操作選單：
echo   1: 增加 Sublime Text 2/3 到系統右鍵選單。
echo   2: 移除 Sublime Text 2/3 右鍵選單。
echo   3: 註冊檔案關聯性(副檔名清單請存在同資料夾內的 ext.txt 文件中)。
echo   4: 移除檔案關聯性。
echo   5: 退出;
echo.
echo   注意事項：
echo   1. 請將此批次檔複製到 Sublime Text 2/3 的資料夾。
echo   2. 確定 Sublime Text 2/3 的執行檔名稱為 sublime_text.exe。
echo   3. 請將需要關聯的副檔名存到到同資料夾內 ext.txt 文件中(每行一個副檔名)。
echo.
echo -----------------------------------------------------------------------
:begin
Set /p u=輸入選單邊號後按下 Enter 鍵：

If "%u%" == "1" Goto regMenu
If "%u%" == "2" Goto unregMenu
If "%u%" == "3" Goto st2file
If "%u%" == "4" Goto unst2file
If "%u%" == "5" exit
If "%u%" == ""  Goto begin

:regMenu
reg add "HKCR\*\shell\Sublime Text 2" /ve /d "Open With Sublime Text 2" /f 
reg add "HKCR\*\shell\Sublime Text 2\command" /ve /d "%cd%\sublime_text.exe %%1" /f 
echo.
echo 已成功註冊右鍵選單
echo.
Goto begin

:unregMenu
reg delete "HKCR\*\shell\Sublime Text 2" /f
echo.
echo 已成功移除右鍵選單
echo.
Goto begin

:st2file
reg add "HKCR\st2file" /ve /d "文字檔案" /f
reg add "HKCR\st2file\DefaultIcon" /ve /d "%cd%\sublime_text.exe" /f
reg add "HKCR\st2file\shell\open\command" /ve /d "%cd%\sublime_text.exe %%1" /f
For /F "eol=;" %%e in (ext.txt) Do (
        Rem echo %%e
        (for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "HKCR\.%%e" /ve') do (
            If NOT "%%c" == "st2file" (
                reg add "HKCR\.%%e" /v "st2_backup" /d "%%c" /f
            )
        ))
        assoc .%%e=st2file
    )
echo.
echo 已成功注冊檔案關聯性
echo.
Goto begin

:unst2file
reg delete "HKCR\st2file" /f
For /F "eol=;" %%e in (ext.txt) Do (
        Rem echo %%e
        (for /f "skip=2 tokens=1,2,* delims= " %%a in ('reg query "HKCR\.%%e" /v "st2_backup"') do (
            reg add "HKCR\.%%e" /ve /d "%%c" /f
            reg delete "HKCR\.%%e" /V "st2_backup" /f
        ))
    )
echo.
echo 已成功移除檔案關聯性
echo.
Goto begin
