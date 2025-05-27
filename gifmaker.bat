@echo off
setlocal EnableDelayedExpansion

:: Set font path
set "fontpath=C\:/Windows/Fonts/arial.ttf"

:: Supported video and image extensions
set extensions=mp4 mov avi mkv webm flv wmv jpg jpeg png bmp gif tiff webp

:: Create temp file list
set "tempFile=%TEMP%\videolist.txt"
if exist "%tempFile%" del "%tempFile%"

:: Search for supported video and image files
for %%e in (%extensions%) do (
    for %%f in (*.%%e) do echo %%f>> "%tempFile%"
)

:: Load file list
set /a index=0
for /f "tokens=*" %%F in (%tempFile%) do (
    set /a index+=1
    set "file!index!=%%F"
)

if !index! EQU 0 (
    echo No video or image files found!
    pause
    exit /b
)

:selectFile
cls
echo Found !index! file(s):
for /L %%i in (1,1,!index!) do (
    call echo %%i. !file%%i!
)
echo.
set /p choice="Enter the number of the file to convert: "
if "!file%choice%!"=="" (
    echo Invalid choice.
    timeout /t 2 >nul
    goto selectFile
)
set "selectedFile=!file%choice%!"
if "!selectedFile!"=="" (
    echo Invalid file selection.
    pause
    exit /b
)
for %%A in ("!selectedFile!") do set "filename=%%~nA"

:: Frame rate selection
:selectFPS
cls
echo Choose frame rate (lower = smaller file size):
echo 1. 1 fps  [Very low motion, tiny file]
echo 2. 5 fps  [Simple animations]
echo 3. 10 fps [Moderate motion]
echo 4. 12 fps [Good balance]
echo 5. 15 fps [Smoother motion]
echo 6. 24 fps [Smooth, bigger file]
echo 7. 30 fps [Very smooth, larger file]
echo 8. Custom
set /p fpsChoice="Enter your choice (1-8): "
if "!fpsChoice!"=="1" set fps=1
if "!fpsChoice!"=="2" set fps=5
if "!fpsChoice!"=="3" set fps=10
if "!fpsChoice!"=="4" set fps=12
if "!fpsChoice!"=="5" set fps=15
if "!fpsChoice!"=="6" set fps=24
if "!fpsChoice!"=="7" set fps=30
if "!fpsChoice!"=="8" set /p fps="Enter custom FPS: "
if "!fps!"=="" goto selectFPS

:: Resolution and aspect ratio selection
:selectRes
cls
echo Choose resolution and aspect ratio:
echo 1. 320x240  [4:3, tiny file]
echo 2. 480x360  [4:3, smaller GIFs]
echo 3. 640x480  [4:3, standard]
echo 4. 640x360  [16:9, HD]
echo 5. 1280x720 [16:9, HD]
echo 6. Original resolution [Maintains aspect ratio]
echo 7. Set width, maintain aspect ratio
echo 8. Set height, maintain aspect ratio
echo 9. Custom width and height
set /p resChoice="Enter your choice (1-9): "
if "!resChoice!"=="1" set scale=320:240
if "!resChoice!"=="2" set scale=480:360
if "!resChoice!"=="3" set scale=640:480
if "!resChoice!"=="4" set scale=640:360
if "!resChoice!"=="5" set scale=1280:720
if "!resChoice!"=="6" set scale=-1:-1
if "!resChoice!"=="7" (
    set /p width="Enter width (e.g., 640): "
    set scale=!width!:-1
)
if "!resChoice!"=="8" (
    set /p height="Enter height (e.g., 360): "
    set scale=-1:!height!
)
if "!resChoice!"=="9" (
    set /p scale="Enter width:height (e.g., 640:360): "
)
if "!scale!"=="" goto selectRes

:: Dithering method selection
:selectDither
cls
echo Choose dithering method for GIF quality:
echo 1. Sierra2_4a [Default, good balance]
echo 2. Floyd_Steinberg [Smooth gradients]
echo 3. Bayer [Patterned, smaller file]
echo 4. None [No dithering, sharp but may lose colors]
set /p ditherChoice="Enter your choice (1-4): "
if "!ditherChoice!"=="1" set dither=sierra2_4a
if "!ditherChoice!"=="2" set dither=floyd_steinberg
if "!ditherChoice!"=="3" set dither=bayer
if "!ditherChoice!"=="4" set dither=none
if "!dither!"=="" goto selectDither

:: Font selection
:selectFont
cls
echo Choose font:
echo 1. Arial
echo 2. Arial Bold
echo 3. Arial Italic
echo 4. Custom
set /p fontChoice="Enter your choice (1-4): "
if "!fontChoice!"=="1" set "fontpath=C\:/Windows/Fonts/arial.ttf"
if "!fontChoice!"=="2" set "fontpath=C\:/Windows/Fonts/arialbd.ttf"
if "!fontChoice!"=="3" set "fontpath=C\:/Windows/Fonts/ariali.ttf"
if "!fontChoice!"=="4" set /p fontpath="Enter full path to font file (e.g., C\:/Windows/Fonts/times.ttf): "
if "!fontpath!"=="" goto selectFont

:: Font color
cls
echo Choose font color (white, black, red, yellow, blue, etc):
set /p fontcolor="Font color: "
if "!fontcolor!"=="" set fontcolor=white

:: Font size
cls
echo Enter font size (e.g., 16=small, 24=medium, 32=large):
set /p fontsize="Font size: "
if "!fontsize!"=="" set fontsize=24

:: Text border
cls
set /p doBorder="Add text border? (y/n): "
if /i "!doBorder!"=="y" (
    set /p borderw="Enter border width (e.g., 2): "
    set /p bordercolor="Enter border color (e.g., black): "
) else (
    set "borderw="
    set "bordercolor="
)

:: Text shadow
cls
set /p doShadow="Add text shadow? (y/n): "
if /i "!doShadow!"=="y" (
    set /p shadowx="Enter shadow x offset (e.g., 2): "
    set /p shadowy="Enter shadow y offset (e.g., 2): "
    set /p shadowcolor="Enter shadow color (e.g., black): "
) else (
    set "shadowx="
    set "shadowy="
    set "shadowcolor="
)

:: Number of text overlays
cls
echo How many text overlays do you want to add? (1-3)
set /p num_texts=
if "!num_texts!" LSS "1" set num_texts=1
if "!num_texts!" GTR "3" set num_texts=3

:: Collect text and positions
for /L %%i in (1,1,!num_texts!) do (
    cls
    echo Enter text for overlay %%i:
    set /p text%%i=
    :selectPos%%i
    cls
    echo Choose position for text %%i:
    echo 1. Top-left
    echo 2. Top-center
    echo 3. Top-right
    echo 4. Middle-left
    echo 5. Middle-center
    echo 6. Middle-right
    echo 7. Bottom-left
    echo 8. Bottom-center
    echo 9. Bottom-right
    echo 10. Custom
    set /p posChoice="Enter your choice (1-10): "
    if "!posChoice!"=="1" set "x%%i=10" & set "y%%i=10"
    if "!posChoice!"=="2" set "x%%i=(w-text_w)/2" & set "y%%i=10"
    if "!posChoice!"=="3" set "x%%i=w-text_w-10" & set "y%%i=10"
    if "!posChoice!"=="4" set "x%%i=10" & set "y%%i=(h-text_h)/2"
    if "!posChoice!"=="5" set "x%%i=(w-text_w)/2" & set "y%%i=(h-text_h)/2"
    if "!posChoice!"=="6" set "x%%i=w-text_w-10" & set "y%%i=(h-text_h)/2"
    if "!posChoice!"=="7" set "x%%i=10" & set "y%%i=h-text_h-10"
    if "!posChoice!"=="8" set "x%%i=(w-text_w)/2" & set "y%%i=h-text_h-10"
    if "!posChoice!"=="9" set "x%%i=w-text_w-10" & set "y%%i=h-text_h-10"
    if "!posChoice!"=="10" (
        set /p x="Enter x position (e.g., 10, (w-text_w)/2): "
        set /p y="Enter y position (e.g., 10, h-60): "
        set "x%%i=!x!"
        set "y%%i=!y!"
    )
    if not defined x%%i (
        echo Invalid choice.
        timeout /t 2 >nul
        goto selectPos%%i
    )
)

:: Optional trimming
cls
set /p doTrim="Trim the video? (y/n): "
if /i "!doTrim!"=="y" (
    set /p startTime="Start time (e.g., 00:00:05): "
    set /p duration="Duration in seconds (e.g., 5): "
    set "trimArgs=-ss !startTime! -t !duration!"
) else (
    set "trimArgs="
)

:: Prompt for output filename
cls
set /p outputName="Enter the name for the output GIF (including .gif), or press enter for default: "
if "!outputName!"=="" set "outputName=!filename!_output.gif"

:: Build drawtext filters
set "drawtext_filters="
for /L %%i in (1,1,!num_texts!) do (
    set "drawtext_filters=!drawtext_filters!drawtext=fontfile='!fontpath!':text='!text%%i!':fontcolor=!fontcolor!:fontsize=!fontsize!:x=!x%%i!:y=!y%%i!:box=1:boxcolor=black@0.5"
    if defined borderw set "drawtext_filters=!drawtext_filters!:borderw=!borderw!:bordercolor=!bordercolor!"
    if defined shadowx set "drawtext_filters=!drawtext_filters!:shadowx=!shadowx!:shadowy=!shadowy!:shadowcolor=!shadowcolor!"
    set "drawtext_filters=!drawtext_filters!,"
)

:: Build FFmpeg command
set "filters=!drawtext_filters!fps=!fps!,scale=!scale!:flags=lanczos[s]; [s]split[a][b]; [a]palettegen[palette]; [b][palette]paletteuse=dither=!dither!"
echo.
echo Generating GIF...
ffmpeg !trimArgs! -i "!selectedFile!" -filter_complex "!filters!" -y "!outputName!"
echo.
echo GIF created: !outputName!
pause
