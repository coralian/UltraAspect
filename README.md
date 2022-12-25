# UltraAspect
# Powershell module for Modifying Game files to support (Super) UltraWide aspect ratios and more

## Supported Aspect ratios:
- 16:9 (1920x1080
- 21:9 (2560x1080 / 5120x2160)
- 21:9 (3440x1440 / 6880x2880)
- 21:9 (3840x1600)
- 32:9 (5120x1440)
- 16:10
- 32:10

Written in powershell core, supports running natively on windows or Unix with Powershell core installed

## Requirements:

- Powershell Core


## Installing:

Utility scripts are provided for using the module, but if you would like to install in your own project:

```
Import-Module UltraAspect
```

Or directly via file path

```
Import-Module -Name ${PSScriptRoot}/UltraAspect.psd1 -Force
```

## Usage:

`UltraAspect.ps1` is the primary script that Imports the UltraAspect Module and calls it's functions.

Clone to a local folder

```
git clone https://github.com/coralian/UltraAspect.git
cd UltraAspect
```
To Update an exe with the values included in this module, navigate to this project folder and call `UltraAspect.ps1` with a parameter to point to your file. Wrap the file path in quotes if it has spaces.

```
.\UltraAspect.ps1 -FilePath "G:\SteamLibrary\steamapps\common\The Witcher 3\bin\x64_dx12\witcher3.exe" 
```

```
.\UltraAspect.ps1 -FilePath "G:\SteamLibrary\steamapps\common\SonicFrontiers\SonicFrontiers.exe"
```


## Why:

While The Witcher 3 supports the resoluton of a of a Samsung 49" CRG9 in game, cutscenes are black-bared to 16:9 unless you hex edit the EXE. I got tired of doing this manually after the 3rd steam update in as many weeks forced me to re-patch the exe. And here we are. 
## Supported games:

Should in THEORY work with any EXE but HEX values that need to be targeted for replacement are likely to change from title to title, but those can be passed as parameters to either the powershell module OR the GoLang Executable doing the actual hex editing. 

```
.\UltraAspect.ps1 -FilePath "G:\PATH\TO\GAME.exe" -ReplaceValue "aa:bb:cc:dd" -FindValue "xx:xx:xx:xx"
```

I have personally only tested with Witcher 3 (V4.0) And Sonic Frontiers, which share the same values for replacement.
## Reference links:

https://en.wikipedia.org/wiki/Ultrawide_formats

https://vulkk.com/2021/06/27/how-to-fix-witcher-3-ultrawide-cutscenes-no-black-bars/

https://steamcommunity.com/app/1237320/discussions/0/3494258076750408802/

