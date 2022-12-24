## Functons for backing up and modifying files

function Update-UltraAspect_File {
    # Requires PowerShell 7 Core and .NET 7 or higher
    [cmdletbinding()]
    param (
        [parameter(Mandatory = $true)]
        [string]$FilePath,
        [parameter(Mandatory = $true)]
        [string]$FindValue,
        [parameter(Mandatory = $true)]
        [string]$ReplaceValue,
        [parameter(Mandatory = $true)]
        [string]$HexEditorCMD,
        [switch]$DebugMode
    )

    try {

        if ($FindValue.Length -ne $ReplaceValue.Length) {
            throw "The find and replace values must be the same length."
        }

        if (-not $DebugMode) {
            Write-Host "`nCalling HexEditorCMD tool to modify file: " -ForegroundColor Yellow
            write-host "$HexEditorCMD -file $FilePath -find "$FindValue" -replace "$ReplaceValue"`n" -ForegroundColor Blue
            & $HexEditorCMD -file $FilePath -find "$FindValue" -replace "$ReplaceValue"
        }
        else {
            Write-Host "`nNo changes were made to the file." -ForegroundColor Green
        }
    }
    catch {
        Write-Error "`nAn error occurred: $($_.Exception.Message)" 
    }
}

function Backup-UltraAspect_File {
    param (
        [string]$FilePath,
        [switch]$DebugMode
    )
    # Make a copy of the original file
    if (-not $DebugMode) {
        Write-Host "`nBacking up original file: " -ForegroundColor Green -NoNewline
        $backupFilePath = $FilePath + '-backup-' + (Get-Date -Format "yyyy-MM-dd_hh-mm")
        Write-Host $backupFilePath.split("\")[-1] -ForegroundColor Yellow
        Copy-Item -Path $FilePath -Destination $backupFilePath
    }
}
