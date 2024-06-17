# Get-Filehashes.ps1

This PowerShell script prompts the user for a file path and computes MD5, SHA1, and SHA256 hashes for the specified file. The script then saves the computed hashes to an output file, ensuring the output directory is valid and writable.

## Script Overview

### User Prompts

1. **File Path**: 
   - The script prompts the user to enter the path of the file to compute hashes from.
   - Validates if the file exists.

2. **Output Path**:
   - The script prompts the user to enter the output path for saving the hash results.
   - Handles cases where only a file name is provided and combines it with the current directory.
   - Validates if the output directory exists and checks write access.

### Main Steps

1. **Prompt for File Path**:
   - Uses `Read-Host` to get the file path input from the user.
   - Removes any quotes from the input and checks if the file exists.

2. **Prompt for Output Path**:
   - Uses `Read-Host` to get the output path for saving the hashes.
   - Ensures the path is correctly formatted, handles file name only inputs, and checks if the directory exists and is writable.

3. **Compute Hashes**:
   - Defines a function `Get-Hash` to compute hashes using the specified algorithm (MD5, SHA1, SHA256).
   - Computes the hashes for the specified file.

4. **Output Hashes**:
   - Prepares the output content with computed hashes.
   - Writes the hashes to the specified output file, handling any errors related to file permissions.
