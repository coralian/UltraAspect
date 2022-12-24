$verbose_output = $false
$manifest = @{
    path        = 'UltraAspect.psd1' 
    RootModule  = 'UltraAspect.psm1'  
    Author      = 'Chris Cossiah'
    CompanyName = 'NOP'
    Description = 'Modify (game) EXE files to support Ultrawide aspect ratios + Others'
    ModuleVersion = '0.0.2'
}
function Build-Manifest {
    # if a current manifest file does not exist, create one with the above parameters
    if (!(Test-Path -Path $manifest.path)) {
        Write-Information -messageData "$manifest.path does not exist, creating..."
        New-ModuleManifest @manifest
    }
}
function Update-ImportedFunctions {
    [cmdletbinding()]

    Param()

    $moduleName = Get-Item $manifest.path | ForEach-Object BaseName
    $function_folder = $moduleName + "_Functions"

    # RegEx matches files like Noun-verb.ps1 only
    
    $functionNames = Get-ChildItem -path "${PSScriptRoot}/$function_folder" -Recurse | Where-Object { $_.Name -match "^[^\.]+-[^\.]+\.ps1$" } -PipelineVariable file | ForEach-Object {
        $ast = [System.Management.Automation.Language.Parser]::ParseFile($file.FullName, [ref] $null, [ref] $null)
        if ($ast.EndBlock.Statements.Name) {
            $ast.EndBlock.Statements.Name
        }
    }

    $functions_to_import = @($functionNames)
    Write-Host "Adding functions:" -ForegroundColor DarkGreen
    # write-host with ForEach to use forground color
    $functions_to_import | ForEach-Object -Process {Write-Host "♦$_" -ForegroundColor DarkBlue}

    Update-ModuleManifest -Path ".\$($moduleName).psd1" -FunctionsToExport $functions_to_import
    Import-Module "./$moduleName.psm1" -Force -Verbose:$verbose_output
    Write-Host "(Re)Imported $moduleName on powershell host" -ForegroundColor DarkGreen
}

Build-Manifest
Update-ImportedFunctions
