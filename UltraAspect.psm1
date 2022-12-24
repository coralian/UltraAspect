# Dot source functions as module members.

if (Test-Path "${PSScriptRoot}/UltraAspect_Functions"){
    Get-ChildItem "${PSScriptRoot}/UltraAspect_Functions/*.ps1" | ForEach-Object {. $_.FullName}
}
