[cmdletbinding()]
param(
    [string]$FilePath,
    [string]$FindValue = "39:8E:E3:3F",
    [string]$ReplaceValue,
    [string]$HexEditorCMD = "$PSScriptRoot\HexEditorCMD\HexEditorCMD.exe",
    [switch]$DebugMode,
    [switch]$NoBackup
)

Import-Module -Name ${PSScriptRoot}/UltraAspect.psd1 -Force -Verbose:$False
# Install-GoLang

$params = @{}
$ParameterList = (Get-Command -Name $MyInvocation.InvocationName).Parameters
foreach ($key in $ParameterList.keys) {
    $var = Get-Variable -Name $key -ErrorAction SilentlyContinue
    if ($var) {
        $params.Add("$($var.name)", "$($var.value)")
    }
}
$params = [PSCustomObject]$params

function Get-MonitorAspectRatio {
    param (
        [Parameter(Mandatory = $false)]
        [int]$Width,

        [Parameter(Mandatory = $false)]
        [int]$Height
    )

    # Check if width and height variables have values
    if (($null -eq $script:ReplaceString) -or ($script:ReplaceString -like "")) {
        if (-not $Width -or -not $Height) {
            # Get resolution of monitor 1
            try { 
                Write-Host "`nGetting Monitor resoluton via powershell Microsoft Powershell Core Module." -ForegroundColor Green
                Install-DisplaySettingsModule
                $Monitor = Get-DisplayResolution | Where-Object { $_.dmDisplayFlags -eq 0 }
                $Width = $Monitor.dmPelsWidth
                $Height = $Monitor.dmPelsHeight
                Write-Host "`nDetected Reslution: $Width x $Height" -ForegroundColor Yellow
            }
            catch {
                $Width = Read-Host "Enter monitor width (in pixels)"
                $Height = Read-Host "Enter monitor height (in pixels)"
            }
        }
        else {
            Write-Host "User Provided Reslution: $Width x $Height "
        }
        # Calculate aspect ratio
        $AspectRatioDEC = [math]::Round(($Width / $Height), 3)
        ## todo: switch over to Hashtable for dataset
        switch ($true) {
            { (($Width -eq 2560) -and ($Height -eq 1080 )) -or 
                (($Width -eq 5120) -and ($Height -eq 2160 )) -or
                ($AspectRatioDEC -eq 2.37) } {
                $script:AspectRatioHuman = "21:9 (2.37~)(2560x1080 / 5120x2160)"
                $script:ReplaceString = "26:B4:17:40"
            }
                
            { (($Width -eq 3440) -and ($Height -eq 1440 )) -or 
                (($Width -eq 6880) -and ($Height -eq 2880 )) 
                ($AspectRatioDEC -eq 2.389) } {
                $script:AspectRatioHuman = "21:9 (2.38~)(3440x1440 / 6880x2880 )"
                $script:ReplaceString = "8E:E3:18:40"
            }
            
            { (($Width -eq 3840) -and ($Height -eq 1600 )) -or
                ($AspectRatioDEC -eq 2.4) } {
                $script:AspectRatioHuman = "21:9 (2.4)(3840x1600)"
                $script:ReplaceString = "9A:99:19:40"
            }
            
            { (($Width -eq 5120) -and ($Height -eq 1440 )) -or
                ($AspectRatioDEC -eq 3.556) } {
                $script:AspectRatioHuman = "32:9 (3.55~)(5120x1440)"
                $script:ReplaceString = "39:8E:63:40"
            }
            
            { (($Width -eq 1920) -and ($Height -eq 1080 )) -or
                ($AspectRatioDEC -eq 1.778) } {
                $script:AspectRatioHuman = "16:9 (1.77~)(1920x1080)"
                $script:ReplaceString = "39:8E:E3:3F"
            }
            
            { ($AspectRatioDEC -eq 1.6) } {
                $script:AspectRatioHuman = "16:10 (1.6)"
                $script:ReplaceString = "CD:CC:CC:3F"
            }
            
            { ($AspectRatioDEC -eq 3.2) } {
                $script:AspectRatioHuman = "32:10 (1.6)"
                $script:ReplaceString = "CD:CC:4C:40"
            }
            
            { ($AspectRatioDEC -eq 3.75) } {
                $script:AspectRatioHuman = "3x5:4 (3.75)"
                $script:ReplaceString = "00:00:70:40"
            }
            
            { ($AspectRatioDEC -eq 4.8) } {
                $script:AspectRatioHuman = "3x16:10 (4.8)"
                $script:ReplaceString = "00:00:70:40"
            }
        }
    }
    else {
        Write-Host "User defined Hex Value: $script:ReplaceString" -ForegroundColor Green
    }
}

$script:aspectRatios = @{
    "Standard (1920x1080)"              = @{
        "Aspect Ratio" = "16:9"
        "Value"        = 1.778
        "Hex Value"    = "39:8E:E3:3F"
    }
    "Ultrawide 16:10"                   = @{
        "Aspect Ratio" = "32:10"
        "Value"        = 1.6
        "Hex Value"    = "CD:CC:CC:3F"
    }
    "Ultrawide (2560x1080 / 5120x2160)" = @{
        "Aspect Ratio" = "21:9"
        "Value"        = 2.37
        "Hex Value"    = "26 B4 17 40"
    }
    "Ultrawide (3440x1440 / 6880x2880)" = @{
        "Aspect Ratio" = "21:9"
        "Value"        = 2.389
        "Hex Value"    = "8E:E3:18:40"
    }
    "Ultrawide (3840x1600)"             = @{
        "Aspect Ratio" = "21:9"
        "Value"        = 2.400
        "Hex Value"    = "9A:99:19:40"
    }
    "Super Ultrawide (5120x1440)"       = @{
        "Aspect Ratio" = "32:9"
        "Value"        = 3.556
        "Hex Value"    = "39:8E:63:40"
    }
    "Super Ultrawide 32:10"             = @{
        "Aspect Ratio" = "32:10"
        "Value"        = 3.2
        "Hex Value"    = "CD:CC:4C:40"
    }
}


$script:ReplaceString = $ReplaceValue
Get-MonitorAspectRatio
$ReplaceValue = $script:ReplaceString

$yes = New-Object System.Management.Automation.Host.ChoiceDescription "&Yes", "Description."
$no = New-Object System.Management.Automation.Host.ChoiceDescription "&No", "Description."
$exit = New-Object System.Management.Automation.Host.ChoiceDescription "&Exit", "Description."
$options = [System.Management.Automation.Host.ChoiceDescription[]]($yes, $no, $exit)

$EXEName = $filePath.split("\")[-1]
## Use the following each time your want to prompt the use
$title = "Target Aspect Ratio: $script:AspectRatioHuman `nTarget EXE: $EXEName `nHex Editor Path: $HexEditorCMD" 
$message = "`nHex Value be replace: $FindValue `nHex Values to replace with: $ReplaceValue `nAccept Adjutment to new ratio?"
$result = $host.ui.PromptForChoice($title, $message, $options, 2)
switch ($result) {
    0 {
        # Write-Host "Yes"
        if (-not $NoBackup) { Backup-UltraAspect_File -FilePath $FilePath}
        Update-UltraAspect_File -FilePath $FilePath -ReplaceValue $ReplaceValue -FindValue $FindValue -HexEditorCMD $HexEditorCMD
    }1 {
        $Width = Read-Host "`nEnter monitor width (in pixels)"
        $Height = Read-Host "Enter monitor height (in pixels)"
        Get-MonitorAspectRatio
        Write-Host "`nHex Value be replace: $findValue `nHex Values to replace with: $ReplaceValue" -ForegroundColor Yellow
        if (-not $NoBackup) { Backup-UltraAspect_File -FilePath $FilePath}
        Update-UltraAspect_File -FilePath $FilePath -ReplaceValue $ReplaceValue -FindValue $FindValue -HexEditorCMD $HexEditorCMD
        Exit
    }2 {
        Write-Host "Exiting with no changes" -ForegroundColor Yellow
        Exit
    }
}
