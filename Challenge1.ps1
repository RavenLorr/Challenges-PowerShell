# Input parameters
$lastname = $args[0]
$name = $args[1]
$orga = $args[2]
$all = "$name_$lastname"
$userPath = "C:\DossierUtilisateur\$all"

# Validation of input parameters
if ($lastname -eq $null) {
    Write-Error "Last name missing"; exit
}
if ($name -eq $null) {
    Write-Error "First name missing"; exit
}
if ($orga -eq $null) {
    Write-Error "Organization name missing"; exit
}

# Check if the user already exists
if (Get-ADUser -Identity $all) {
    Write-Error "The user already exists"; exit
} else {
    try {
        New-ADUser -Name $all -Path "OU=$orga,DC=lan"
        Write-Output "User $all created successfully"
    } catch {
        Write-Error "Error creating user: $_"; exit
    }
}

# Check if the user folder already exists
if (Test-Path -Path $userPath) {
    Write-Error "The user folder already exists"; exit
} else {
    try {
        New-Item -Path "C:\DossierUtilisateur" -Name $all -Type Directory
        Write-Output "Folder $userPath created successfully"
    } catch {
        Write-Error "Error creating folder: $_"; exit
    }

    try {
        New-SmbShare -Name $all -Path $userPath -FullAccess $all
        Write-Output "Network share $all created successfully"
    } catch {
        Write-Error "Error creating network share: $_"; exit
    }
}

Write-Output "All done :)"