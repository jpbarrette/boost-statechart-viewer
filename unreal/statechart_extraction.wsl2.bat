@echo off

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

for /f %%i in ('wsl wslpath "%ProjectDirectory%"') do set WSLProjectDirectory=%%i
for /f %%i in ('wsl wslpath "%CPPFilePath%"') do set WSLCPPFilePath=%%i
for /f %%i in ('wsl wslpath "%CPPDir%"') do set WSLCPPDir=%%i

echo UnrealEngineDirectory=%UnrealEngineDirectory%
echo ProjectDirectory=%ProjectDirectory%
echo WSLProjectDirectory=%WSLProjectDirectory%
echo WSLCPPFilePath=%WSLCPPFilePath%
echo CPPFile=%CPPFile%
echo WSLCPPDir=%WSLCPPDir%

rem Cross-compiling to linux, which generates the "response" file
echo Extracting compilation options
%UnrealEngineDirectory%\Engine\Binaries\ThirdParty\DotNet\6.0.302\windows\dotnet.exe "%UnrealEngineDirectory%\Engine\Binaries\DotNET\UnrealBuildTool\UnrealBuildTool.dll" AvalonPrototype Linux Development -Project=%ProjectDirectory%\AvalonPrototype.uproject -SingleFile=%CPPFilePath% -log="AvalonPrototype-Linux-Development.txt"

echo Converting compilation options to Linux
rem this is a hack for the fact that most perforce clients will be under windows, so line-ending in dos. Best fix would be to have Perforce server to send it with unix-ending. One of the solution
rem was to set the file as binary with +D, but it means that tools around perforce consider that file as binary, so they don't want to diff.
wsl dos2unix "%WSLProjectDirectory%/Source/AvalonPrototype/Statecharts/convert_response_file_to_unix.py"
rem we use bash -ic because originally my python exec didn't seem to be in PATH for bash, but it was because I was using conda and it's added in PATH though .bashrc. So, I had to use 'bash -ic' to get .bashrc to be executed.

wsl -e bash -ic "%WSLProjectDirectory%/Source/AvalonPrototype/Statecharts/convert_response_file_to_unix.py %WSLProjectDirectory%/Intermediate/Build/Linux/B4D820EA/AvalonPrototype/Development/AvalonPrototype/%CPPFile%.cpp.o.response"

echo Extracting statechart visualization
pushd %UnrealEngineDirectory%\Engine\Source
wsl clang++ -Xclang -load -Xclang %WSLProjectDirectory%/Source/AvalonPrototype/Statecharts/visualizer.so -Xclang -plugin -Xclang visualize-statechart @%WSLProjectDirectory%/Intermediate/Build/Linux/B4D820EA/AvalonPrototype/Development/AvalonPrototype/%CPPFile%.cpp.o.response.bsv -E 
popd

echo Generating pdf file from dot file
wsl -e bash -lic "dot -Tpdf %WSLCPPDir%/%CPPFile%.dot > %WSLCPPDir%/%CPPFile%.pdf"
start %CPPDir%\%CPPFile%.pdf
