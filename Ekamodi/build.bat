set MODBUDDY=C:\Program Files (x86)\Steam\steamapps\common\Sid Meier's Civilization V SDK\ModBuddy\ModBuddy.exe
set MODS_DIR=C:\Users\peluri\Documents\My Games\Sid Meier's Civilization 5\MODS
set MOD_NAME=Monnin Sivilisaatio - Johtaja Eetu

rem "%MODBUDDY%" Ekamodi.civ5sln /project Liideri /clean "Default|x86"
rem "%MODBUDDY%" Ekamodi.civ5sln /project Liideri /build "Default|x86"

rmdir /Q /S "%MODS_DIR%\Mods"
rmdir /Q /S "%MODS_DIR%\%MOD_NAME%"
xcopy /S "Build" "%MODS_DIR%"
