# Prompt for the file path
$filePath = Read-Host "Please enter the path of the file where you need to collect the hashes from (use double quotes if there are spaces in the path)"

# Remove quotes if present
$filePath = $filePath.Trim('"')

# Validate file path
if (-Not (Test-Path $filePath)) {
    Write-Host "Error: File does not exist: $filePath"
    exit 1
}

# Prompt for the output path
$outputPath = Read-Host "Please provide the output path for hash.txt (use double quotes if there are spaces in the path)"

# Remove quotes if present
$outputPath = $outputPath.Trim('"')

# Handle cases where only a file name is provided
if ([System.IO.Path]::GetDirectoryName($outputPath) -eq "") {
    $outputDir = (Get-Location).Path
    $outputPath = [System.IO.Path]::Combine($outputDir, $outputPath)
} else {
    $outputDir = [System.IO.Path]::GetDirectoryName($outputPath)
}

# Validate output directory
if (-Not (Test-Path $outputDir)) {
    Write-Host "Error: Output directory does not exist: $outputDir"
    exit 1
}

# Check if the directory of the output path is writable
try {
    $testFilePath = [System.IO.Path]::Combine($outputDir, [System.IO.Path]::GetRandomFileName())
    Add-Content -Path $testFilePath -Value "Test" -ErrorAction Stop
    Remove-Item -Path $testFilePath -ErrorAction Stop
    Write-Host "Verified: Write access to the output directory is confirmed."
} catch {
    Write-Host "Error: Cannot write to the specified output directory: $outputDir"
    Write-Host "Please ensure you have write permissions or try running PowerShell as Administrator."
    exit 1
}

# Function to compute hash
function Get-Hash($filePath, $hashAlgorithm) {
    $hashAlgorithm = [System.Security.Cryptography.HashAlgorithm]::Create($hashAlgorithm)
    $fileStream = [System.IO.File]::OpenRead($filePath)
    $hashBytes = $hashAlgorithm.ComputeHash($fileStream)
    $fileStream.Close()
    return [BitConverter]::ToString($hashBytes) -replace '-', ''
}

# Calculate MD5, SHA1, and SHA256 hashes
$md5Hash = Get-Hash $filePath "MD5"
$sha1Hash = Get-Hash $filePath "SHA1"
$sha256Hash = Get-Hash $filePath "SHA256"

# Prepare the output
$output = @(
    "MD5: $md5Hash"
    "SHA1: $sha1Hash"
    "SHA256: $sha256Hash"
)

# Write the hashes to the output file
try {
    $output | Out-File -FilePath $outputPath -ErrorAction Stop
    Write-Host "Hashes written to $outputPath"
} catch [System.UnauthorizedAccessException] {
    Write-Host "Error: Access to the path '$outputPath' was denied. Please ensure you have write permissions."
} catch {
    Write-Host "An unexpected error occurred: $_"
}
