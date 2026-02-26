You need to download ffmpeg.exe and put it in the same directory.. 
This batch program searches your current directory for image and video files.. so smash your video, gif, image or whatever in the same folder with this batch file and ffmpeg...
was tested using the full version of ffmpeg found here. https://www.gyan.dev/ffmpeg/builds/


# 🎬 FFmpeg Interactive GIF Generator (Windows Batch)

An interactive Windows Batch script that converts videos or images into high-quality GIFs using FFmpeg, with advanced customization options.

## ✨ Features

- 🎞 Frame rate control (preset or custom)
- 📐 Resolution & aspect ratio scaling
- 🎨 Multiple dithering methods
- 🖊 Custom fonts
- 📝 Up to 3 text overlays
- ✂ Optional trimming
- 🖼 Image support (convert images into GIFs)

---

## 📂 Supported File Types

The script automatically detects supported media files in the same folder:

**Video**
- mp4
- mov
- avi
- mkv
- webm
- flv
- wmv

**Images**
- jpg
- jpeg
- png
- bmp
- gif
- tiff
- webp

---

## 🎞 Frame Rate Options

Choose from presets:

- 1 fps (tiny file size)
- 5 fps
- 10 fps
- 12 fps
- 15 fps
- 24 fps
- 30 fps
- Custom

Lower FPS = smaller file  
Higher FPS = smoother motion

---

## 📐 Resolution & Scaling Options

- 320x240 (4:3)
- 480x360 (4:3)
- 640x480 (4:3)
- 640x360 (16:9)
- 1280x720 (16:9)
- Original resolution
- Custom width (maintain aspect ratio)
- Custom height (maintain aspect ratio)
- Fully custom width and height

Scaling uses Lanczos resampling for better quality.

---

## 🎨 Dithering Methods

Improves color quality within GIF's 256 color limit:

- sierra2_4a (default, balanced)
- floyd_steinberg (smooth gradients)
- bayer (patterned, smaller files)
- none (no dithering)

---

## 🖊 Text Overlay Features

- 1 to 3 overlays
- Custom font (Arial presets or custom file)
- Custom font size
- Custom font color
- Optional border
- Optional shadow
- 9 preset positions
- Custom X/Y positioning
- Semi-transparent background box

---

## ✂ Optional Trimming

Trim your clip before conversion:

Example:
```
Start time: 00:00:05
Duration: 5
```

---

## 🛠 Requirements

### Windows
Designed for Windows CMD.

### FFmpeg (Required)

Install FFmpeg and ensure it is added to your system PATH.

Download:
https://ffmpeg.org/download.html

Verify installation:
```
ffmpeg -version
```

---

## 🚀 How To Use

1. Install FFmpeg.
2. Place the batch file in a folder.
3. Put your video or image files in the same folder.
4. Double-click the batch file.
5. Follow the interactive prompts.
6. Your GIF will be generated in the same folder.

---

## 🧠 How It Works

The script builds a dynamic FFmpeg filter chain using:

- drawtext (text overlays)
- fps (frame rate control)
- scale (resolution control)
- palettegen (optimized GIF palette)
- paletteuse (applies dithering)

This produces higher quality GIFs than basic one-line FFmpeg conversions.

---

## 📝 Output Naming

If you do not provide a custom name:

```
originalfilename_output.gif
```

---

## ⚠ Notes

- Default font path:
  ```
  C:/Windows/Fonts/arial.ttf
  ```
- Custom fonts must use forward slashes:
  ```
  C:/Windows/Fonts/yourfont.ttf
  ```
- Special characters in text may require escaping.

---

## 📜 License

Free to use and modify.
