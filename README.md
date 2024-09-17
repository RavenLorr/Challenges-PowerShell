# PowerShell Challenges

Here are two old PowerShell Challenge that I found while searching my old files so I decided to make them public. Enjoy ^-^

## First Challenge

**Create a PowerShell** script that will **create a user**, add a **folder with their name**, and **adjust network rights** (SMBShare) on this folder. Here are the details:
* The script receives the user's **last name** as a parameter.
* The script receives the user's **first name** as a parameter.
* The script receives an **OU** as a parameter.
* The script will create the user in this format: **firstname_lastname** in the **organizational unit** received as a parameter.
* The script will then create a **subfolder** with the **user's name** in the folder `c:\DossierUtilisateur`.
* Finally, a network share of this folder with full control will be given to the user.
**Add validation (folder already exists, missing input parameters, etc.).**

## Code :

```powershell
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
```
## Second Challenge

**First, create** this folder structure.
![Image Not loading](/Image1.png)
Then create **3 files of each** type: .txt, .png, and .wav, and mix them in the directories (you will have **9 files** in total).

Once this is done, create a **PowerShell** script that will **move the files** to the correct directory. 
* [.txt]() -> *Codes*
* [.png]() -> *Images*
* [.wav]() -> *Audio*

**Note** that your script should **work regardless of the number of files**. Additionally, the script should **display the total** number of files moved.

## Code :

```powershell
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
```

## License

[MIT](https://choosealicense.com/licenses/mit/)
