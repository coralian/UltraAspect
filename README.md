# UltraAspect
# Powershell module for Modifying Game files to support (Super) UltraWide aspect ratios and more

## Supported Aspect ratios:
- 16:9 (1920x1080)
- 21:9 (2560x1080 / 5120x2160)
- 21:9 (3440x1440 / 6880x2880)
- 21:9 (3840x1600)
- 32:9 (5120x1440)
- 16:10
- 32:10

Written in Powershell core V7 and Go, supports running natively on windows or Unix with Powershell core installed

## Requirements:

- Powershell Core V7: https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3
- Windows 10+ (Unix Coming soon)

## Installing:

Does not require additinal install outside of having powershell core 

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

To Update an exe with the values included in this module

1. Clone to a local folder
2. Navigate to this project folder
3. Run `UltraAspect.ps1` with a parameter to point to your file. Wrap the file path in quotes if it has spaces.

```
git clone https://github.com/coralian/UltraAspect.git
cd UltraAspect
.\UltraAspect.ps1 -FilePath "G:\SteamLibrary\steamapps\common\The Witcher 3\bin\x64_dx12\witcher3.exe" 
```

```
.\UltraAspect.ps1 -FilePath "G:\SteamLibrary\steamapps\common\SonicFrontiers\SonicFrontiers.exe"
```

Default usage with no flags (other than file path), the resolution of the primary monoitor is detected, and an aspect ratio is suggested to the user. If the suggested value is not correct or desired, the user can then manually specify a resolution to get the desired aspect ratio


## Why:

While The Witcher 3 supports the resoluton of a of a Samsung 49" CRG9 in game, cutscenes are black-bared to 16:9 unless you hex edit the EXE. I got tired of doing this manually after the 3rd steam update in as many weeks forced me to re-patch the exe. And here we are. 

## Supported games:

Should in THEORY work with any EXE that uses common HEX values, but are suject to change from title to title, but those can be passed as parameters to either the powershell module OR the GoLang Executable doing the actual hex editing. 

Powershell - File backup + feedback
```
.\UltraAspect.ps1 -FilePath "G:\PATH\TO\GAME.exe" -ReplaceValue "aa:bb:cc:dd" -FindValue "xx:xx:xx:xx"
```

Go - Raw file byte changes, no backup
```
.\HexEditorCMD.exe -FilePath "G:\PATH\TO\GAME.exe" -ReplaceValue "aa:bb:cc:dd" -FindValue "xx:xx:xx:xx"
```

I have personally only tested with Witcher 3 (V4.0) And Sonic Frontiers, which use common values.
## Reference links:

https://en.wikipedia.org/wiki/Ultrawide_formats

https://www.wsgf.org/article/common-hex-values

https://vulkk.com/2021/06/27/how-to-fix-witcher-3-ultrawide-cutscenes-no-black-bars/

https://steamcommunity.com/app/1237320/discussions/0/3494258076750408802/

