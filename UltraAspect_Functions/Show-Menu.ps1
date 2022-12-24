function Show-Menu {
    param(
        [Parameter(Mandatory = $true)]
        [hashtable]$AspectRatios
    )

    # Display the menu
    Write-Host "Select an aspect ratio:"
    $index = 1
    foreach ($key in $AspectRatios.Keys) {
        Write-Host "$index. $key ($($AspectRatios[$key]['Aspect Ratio']))"
        $index++
    }

    # Get the user's selection
    $selection = Read-Host "Enter the number of your selection"

    # Validate the selection
    if ($selection -lt 1 -or $selection -gt $AspectRatios.Count) {
        Write-Host "Invalid selection"
        return
    }

    # Get the key of the selected item
    $selectedKey = $AspectRatios.Keys[$selection - 1]

    # Display the selected item's aspect ratio
    Write-Host "You selected $selectedKey ($($AspectRatios[$selectedKey]['Aspect Ratio']))"
}
