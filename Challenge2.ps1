# Get all files recursively from the specified directory
$files = Get-ChildItem "C:\Assets\" -Recurse -Filter "*.*"
$cpt = 0

# Ensure destination directories exist
$destDirs = @("C:\Assets\Audio", "C:\Assets\Codes", "C:\Assets\Images")
foreach ($dir in $destDirs) {
    if (-not (Test-Path -Path $dir)) {
        New-Item -Path $dir -ItemType Directory
    }
}

# Move files to the appropriate directories based on their extensions
foreach ($name in $files) {
    $extn = $name.Extension
    try {
        if ($extn -eq ".wav") {
            Move-Item -Path $name.FullName -Destination "C:\Assets\Audio"
            $cpt++
        } elseif ($extn -eq ".txt") {
            Move-Item -Path $name.FullName -Destination "C:\Assets\Codes"
            $cpt++
        } elseif ($extn -eq ".png") {
            Move-Item -Path $name.FullName -Destination "C:\Assets\Images"
            $cpt++
        }
    } catch {
        Write-Error "Error moving file $($name.FullName): $_"
    }
}

# Output the total number of files moved
Write-Output "$($cpt) files have been moved"