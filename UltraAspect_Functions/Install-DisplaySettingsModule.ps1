
function Install-DisplaySettingsModule {
    # Check if the DisplaySettings module is already installed
    if (Get-Module -Name DisplaySettings -ListAvailable) {
        Write-host "The DisplaySettings module is already installed." -ForegroundColor Green
    }
    else {
        # Install the DisplaySettings module from the PowerShell Gallery
        Write-host "`nThe DisplaySettings module needs to be installed, downloading from MS powershell gallery." -ForegroundColor Yellow
        Write-host "May report as a 'Untrusted repository' on Win10" -ForegroundColor Yellow
        Install-Module -Name DisplaySettings -Scope CurrentUser
    }
}
