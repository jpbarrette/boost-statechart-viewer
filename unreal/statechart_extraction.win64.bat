rem @echo off

rem TODO:
rem
rem  * Maybe we need this to be a Makefile. It will allow us to skip up-to-date dependencies generation and errors handling.

set UnrealEngineDirectory=%~f1
set ProjectDirectory=%~dp0
rem remove trailing backslash. If we let the trailing slash it ends up escaping the double quote
rem in the "for" command that runs wslpath.

IF NOT '%~x2' =='.cpp' (
echo %~x2
echo statechart_extraction.bat needs to be executed on a cpp file. It was executed on %~f2
exit /B 1
)


IF %ProjectDirectory:~-1%==\ SET ProjectDirectory=%ProjectDirectory:~0,-1%
set CPPFilePath=%~f2
set CPPFile=%~n2
set CPPDir=%~dp2
IF %CPPDir:~-1%==\ SET CPPDir=%CPPDir:~0,-1%

echo UnrealEngineDirectory=%UnrealEngineDirectory%
echo ProjectDirectory=%ProjectDirectory%
echo CPPFile=%CPPFile%


rem Cross-compiling to linux, which generates the "response" file
echo Extracting compilation options
REM %UnrealEngineDirectory%\Engine\Binaries\ThirdParty\DotNet\6.0.302\windows\dotnet.exe "%UnrealEngineDirectory%\Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.dll" AvalonPrototypeEditor Win64 Development -Compiler=Clang -Project=%ProjectDirectory%\AvalonPrototype.uproject -SingleFile=%CPPFilePath% -log="AvalonPrototype-Win64-Development.txt"

echo Extracting statechart visualization
pushd %UnrealEngineDirectory%\Engine\Source
REM "C:\Program Files\LLVM\bin\clang-cl.exe" @%ProjectDirectory%\Intermediate\Build\Win64\UnrealEditor\Development\AvalonPrototype\%CPPFile%.cpp.obj.response 


"C:\Program Files\LLVM\bin\clang-cl.exe" -Xclang -load -Xclang C:\Users\Jean-PhilippeBarrett\Documents\Projects\boost-statechart-viewer\Release\visualizer.dll -Xclang -plugin -Xclang visualize_statechart @%ProjectDirectory%\Intermediate\Build\Win64\UnrealEditor\Development\AvalonPrototype\%CPPFile%.cpp.obj.response -E 

popd

REM echo Generating pdf file from dot file
REM wsl -e bash -lic "dot -Tpdf %WSLCPPDir%/%CPPFile%.dot > %WSLCPPDir%/%CPPFile%.pdf"
REM start %CPPDir%\%CPPFile%.pdf

