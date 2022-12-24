function Install-GoLang {
	# Check if Go is already installed
	if (Get-Command go -ErrorAction Ignore) {
		Write-Output "Go is already installed"
		return
	}

	# Determine the appropriate URL and file name for the Go installer
	$url = "https://go.dev/dl/go1.19.4.windows-amd64.msi"
	$file = ""
	if ($env:OS -eq "Windows_NT") {
		# Windows
		$html = Invoke-WebRequest $url
		$link = ($html.Links | Where-Object { $_.innerHTML -match "go.*windows-amd64.msi" }).href
		$url += $link
		$file = "$env:temp\go.msi"
	}

	# Download the Go installer
	Invoke-WebRequest $url -OutFile $file

	# Install Go
	if ($env:OS -eq "Windows_NT") {
		Start-Process -FilePath msiexec.exe -ArgumentList "/i $file /norestart" -Wait
	}
}
